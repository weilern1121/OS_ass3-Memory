#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"
#include "mmu.h"

// Memory allocator by Kernighan and Ritchie,
// The C programming Language, 2nd ed.  Section 8.7.

typedef long Align;

union header {
    struct {
        union header *ptr;
        uint size;
    } s;
    Align x;
};

typedef union header Header;

static Header base;
static Header *freep;

/*-------  pmalloc struct  ---------------*/
struct PMHeader {
    int PMheaderID;           //page id- used for debbug
    char *PMadress;       // page offset in swap file
    struct PMHeader *PMnext; //pointer to next Ppage
    int PMprotectedPage; //FLAG if protect_page called on this page
};

int nextID = 1;
int PMcounter = 0;
static struct PMHeader *PMinit;
static struct PMHeader *tail;


/*-------  pmalloc struct  ---------------*/

void
free(void *ap) {
    if (DEBUGMODE == 3)
        printf(1, "FREE-\t");
    Header *bp, *p;

    bp = (Header *) ap - 1;
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr) {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    } else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp) {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    } else
        p->s.ptr = bp;
    freep = p;
    if (DEBUGMODE == 3)
        printf(1, ">FREE-DONE!\t");
}

static Header *
morecore(uint nu) {
    if (DEBUGMODE == 3)
        printf(1, "MORECORE-");
    char *p;
    Header *hp;
    if (nu < 4096)
        nu = 4096;
    p = sbrk(nu * sizeof(Header));
    if (p == (char *) -1)
        return 0;
    hp = (Header *) p;
    hp->s.size = nu;
    free((void *) (hp + 1));
    if (DEBUGMODE == 3)
        printf(1, ">MORECORE-DONE!\t");
    return freep;
}


void *
malloc(uint nbytes) {
    if (DEBUGMODE == 3)
        printf(1, "MALLOC-");
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    if ((prevp = freep) == 0) {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
        if (p->s.size >= nunits) {
            if (p->s.size == nunits)
                prevp->s.ptr = p->s.ptr;
            else {
                p->s.size -= nunits;
                p += p->s.size;
                p->s.size = nunits;
            }
            freep = prevp;
            if (DEBUGMODE == 3)
                printf(1, ">MALLOC-done!\t");
            return (void *) (p + 1);
        }
        if (p == freep)
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}


void *
pmalloc(void) {
    if (DEBUGMODE == 3)
        printf(1, "PMALLOC-");
    struct PMHeader *nh = malloc(sizeof(struct PMHeader));
    char *tmpAdr = sbrk(4096); //point to the first free place
    if ((int) tmpAdr % 4096 != 0) //if not align->fix this
        *tmpAdr = (char) PGROUNDUP((int) tmpAdr);

    //init PMHeader
    nh->PMheaderID = nextID++;
    nh->PMnext = 0;
    nh->PMadress = tmpAdr;
    nh->PMprotectedPage = 0;

    //if first-> PMpage=tail=nh
    if (PMcounter == 0) {
        PMinit = nh; //set PMinit link
        tail = nh;
    } else { //else- add new page to the end of PMlist
        tail->PMnext = nh;
        tail = tail->PMnext;
    }
    //turn PMflag on and W flag off
    turnOnW(nh->PMadress);//TODO
    turnOnPM(nh->PMadress);
    //fresh PTE
    updatePTE();
    PMcounter++;
    if (DEBUGMODE == 3)
        printf(1, ">PMALLOC-DONE!\n");
    return tmpAdr;
}

int
protect_page(void *ap) {
    if (DEBUGMODE == 3)
        printf(1, "PROTECT_PAGE-");
    if (ap) {
        if ((int) ap % 4096 != 0) {
            if (DEBUGMODE == 3)
                printf(1, ">PROTECT_PAGE-ERROR-NOT_ALIGN!\n");
            return -1;
        }
        if (checkOnPM(ap)) { //if PTE_PM off -can't protect not pmalloc page
            turnOffW(ap);
            updatePTE();
            updateProc(1); // protectedPages++
            //turn on flag
            struct PMHeader *PMap = PMinit;
            while (PMap->PMnext != 0 && PMap->PMadress != ap)
                PMap = PMap->PMnext;
            if (PMap->PMadress != ap) {
                printf(2, "PROBLEM with ap:%d\n", ap);
                return -1;
            }
            //got here ->MPap points the protected link
            PMap->PMprotectedPage = 1;//turn on FLAG
            if (DEBUGMODE == 3)
                printf(1, ">PROTECT_PAGE-DONE!\n");
            return 1;
        } else {
            if (DEBUGMODE == 3)
                printf(1, ">PROTECT_PAGE-ERROR!-checkOnPM(PMap->PMadress)\n");
            return -1;
        }
    }
    if (DEBUGMODE == 3)
        printf(1, ">PROTECT_PAGE-ERROR!\n");
    return -1;
}


void
printPMList(void) {
    struct PMHeader *tmp2 = PMinit;
    printf(1, "\nPMlist:\t");
    for (int i = 0; i < PMcounter; i++, tmp2 = tmp2->PMnext)
        printf(2, "%d\t", tmp2->PMadress);
    printf(1, "\n\n");
}

//return 1 if ap is address of PMALLOC page ; 0 otherwise
int
checkIfPM(void *p) {
    struct PMHeader *tmp = PMinit;
    for (int i = 0; i < PMcounter; i++) {
        if (tmp->PMadress == p)
            return 1;
    }
    return 0;
}

int
pfree(void *ap) {
    if (DEBUGMODE == 3)
        printf(1, "PFREE-");

    //validation check
    if (PMcounter == 0) {
        if (DEBUGMODE == 3)
            printf(1, "PFREE-ERROR!->not have pages that were pmallocced\n");
        return -1;
    }

    if (ap) {
        struct PMHeader *PMap = PMinit;
        struct PMHeader *tmp = PMinit;
        //check aligned
        if ((int) ap % 4096 != 0) {
            if (DEBUGMODE == 3)
                printf(1, "PFREE-ERROR!-NOT_ALIGN!\n");
            return -1;
        }
        //check that the pm is on and W is off
        if (checkIfPM(ap)) {
            //clean W & PM PTE flags
            turnOffW(PMap);
            turnOffPM(PMap);
            //fresh PTE
            updatePTE();
            //update PMlist
            PMcounter--;
            if (PMcounter == 0) {//if true ->reset PMlist
                if (PMinit->PMprotectedPage)//if was protect_page ->update counter in proc
                    protect_page(0);
                PMinit = 0;
                tail = 0;
            } else {   //remove PMap from PMlist
                //move PMap to his link
                while (PMap->PMnext != 0 && PMap->PMadress != ap)
                    PMap = PMap->PMnext;
                if (PMap->PMadress != ap) {
                    printf(2, "PROBLEM with ap:%d\n", ap);
                    return -1;
                }
                if (tmp->PMheaderID == PMap->PMheaderID) {//happens when both point on the first link
                    if (PMap->PMprotectedPage)//if was protect_page ->update counter in proc
                        protect_page(0);
                    PMinit = PMinit->PMnext;
                } else {
                    //move tmp to point on PMap
                    while (tmp->PMnext->PMheaderID != PMap->PMheaderID)
                        tmp = tmp->PMnext;

                    //got here - tmp.next=PMap
                    if (PMap->PMprotectedPage)//if was protect_page ->update counter in proc
                        protect_page(0);
                    tmp->PMnext = PMap->PMnext;
                }
            }
            if (DEBUGMODE == 3)
                printf(1, ">PFREE-DONE!\t");
            return 1;
        } else { //got here - ap is not page that pmalloced
            if (DEBUGMODE == 3) {
                printf(2, "PFREE-ERROR!->checkOnPM_PMap->PMadress:%d\n\n", ap);
                printPMList();
            }
            return -1;
        }
    }
    if (DEBUGMODE == 3)
        printf(1, ">PFREE-ERROR!\t");
    return -1;
}
