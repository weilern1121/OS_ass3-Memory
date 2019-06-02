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
    struct  PMHeader *PMnext; //pointer to next Ppage
    int PMprotectedPage; //FLAG if protect_page called on this page
};

int nextID=1;
int PMcounter=0;
static struct PMHeader * PMinit;
static struct PMHeader * tail;


/*-------  pmalloc struct  ---------------*/

void
free(void *ap)
{
    if (DEBUGMODE == 3)
        printf(1,"FREE-\t");
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
    if (DEBUGMODE == 3)
        printf(1,">FREE-DONE!\t");
}

static Header*
morecore(uint nu)
{
    if (DEBUGMODE == 3)
        printf(1,"MORECORE-");
  char *p;
  Header *hp;
//notFromPmalloc- because in this specific func there is a need for smaller sbrk
  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
    if (DEBUGMODE == 3)
        printf(1,">MORECORE-DONE!\t");
  return freep;
}


void*
malloc(uint nbytes)
{
    if (DEBUGMODE == 3)
        printf(1,"MALLOC-");
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    if((prevp = freep) == 0){
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
        if(p->s.size >= nunits){
            if(p->s.size == nunits)
                prevp->s.ptr = p->s.ptr;
            else {
                p->s.size -= nunits;
                p += p->s.size;
                p->s.size = nunits;
            }
            freep = prevp;
            if (DEBUGMODE == 3)
                printf(1,">MALLOC-done!\t");
            return (void*)(p + 1);
        }
        if(p == freep)
            if((p = morecore(nunits)) == 0)
                return 0;
    }
}


void*
pmalloc(void)
{
    if (DEBUGMODE == 3)
        printf(1,"PMALLOC-");
    struct PMHeader *nh=malloc(sizeof(struct PMHeader));
    char *tmpAdr=sbrk(4096); //point to the first free place
    if((int)tmpAdr % 4096 != 0) //if not align->fix this
        *tmpAdr= (char) PGROUNDUP((int)tmpAdr);

    //init PMHeader
    nh->PMheaderID=nextID++;
    nh->PMnext=0;
    nh->PMadress=tmpAdr;
    nh->PMprotectedPage=0;

    //if first-> PMpage=tail=nh
    if(PMcounter==0){
        PMinit=nh; //set PMinit link
        tail=nh;
    }
    else{ //else- add new page to the end of PMlist
        tail->PMnext=nh;
        tail=tail->PMnext;
    }

    //turn PMflag on and W flag off
    turnOnW(nh->PMadress);//TODO
    turnOnPM(nh->PMadress);

    //fresh PTE
    updatePTE();
    updateProc(3);// update proc's pagesCounter
    PMcounter++;
    if (DEBUGMODE == 3)
        printf(1,">PMALLOC-DONE!\n");
    return tmpAdr;

}

int
protect_page(void* ap)
{
    if (DEBUGMODE == 3)
        printf(1,"PROTECT_PAGE-");
    if(ap){
        if((int)ap % 4096 !=0){
            if (DEBUGMODE == 3)
                printf(1,">PROTECT_PAGE-ERROR-NOT_ALIGN!\n");
            return -1;
        }
        if(checkOnPM(ap)) { //if PTE_PM off -can't protect not pmalloc page
            turnOffW(ap);
            updatePTE();
            updateProc(1); //1->++
            //turn on flag
            struct PMHeader *PMap = PMinit;
            while(PMap->PMnext!=0 && PMap->PMadress!=ap)
                PMap=PMap->PMnext;
            if(PMap->PMadress!=ap){
                printf(2,"PROBLEM with ap:%d\n",ap);
                return -1;
            }
            //got here ->MPap points the protected link
            PMap->PMprotectedPage=1;//turn on FLAG

            if (DEBUGMODE == 3)
                printf(1, ">PROTECT_PAGE-DONE!\n");
            return 1;
        }
        else{
            if (DEBUGMODE == 3)
                printf(1,">PROTECT_PAGE-ERROR!-checkOnPM(PMap->PMadress)\n");
            return -1;
        }
    }
    if (DEBUGMODE == 3)
        printf(1,">PROTECT_PAGE-ERROR!\n");
    return -1;
}


void
printPMList(void){
    struct PMHeader *tmp2 = PMinit;
    printf(1,"\nPMlist:\t");
    for(int i=0; i<PMcounter; i++, tmp2=tmp2->PMnext)
        printf(2,"%d\t",tmp2->PMadress);
    printf(1,"\n\n");
}

int
pfree(void* ap) {
    if (DEBUGMODE == 3)
        printf(1,"PFREE-");

    //validation check
    if(PMcounter==0){
        if (DEBUGMODE == 3)
            printf(1,"PFREE-ERROR!->not have pages that were pmallocced\n");
        return -1;
    }

    if (ap) {
        struct PMHeader *PMap = PMinit;
        struct PMHeader *tmp = PMinit;

        //check aligned
        if((int)ap % 4096 != 0){
            if (DEBUGMODE == 3)
                printf(1,"PFREE-ERROR!-NOT_ALIGN!\n");
            return -1;
        }
        //check that the pm is on and W is off
        //if ( checkOnPM( ap ) ) {
            //clean W & PM PTE flags
            turnOffW(PMap);
            turnOffPM(PMap);
            //fresh PTE
            updatePTE();
            //update PMlist
            PMcounter--;
            if(PMcounter==0){//if true ->reset PMlist
                if(PMinit->PMprotectedPage)//if was protect_page ->update counter in proc
                    protect_page(0);
                PMinit=0;
                tail=0;
            }
            else {   //remove PMap from PMlist
                //move PMap to his link
                while(PMap->PMnext!=0 && PMap->PMadress!=ap)
                    PMap=PMap->PMnext;
                if(PMap->PMadress!=ap){
                    printf(2,"PROBLEM with ap:%d\n",ap);
                    return -1;
                }
                /*printf(2,"PMap:%d\ttmp:%d\n",PMap->PMadress,tmp->PMadress);
                printf(2,"ap:%d\n",ap);
                printf(2,"tmp->PMnext->PMheaderID:%d\tPMap->PMheaderID:%d\n",tmp->PMnext->PMheaderID,PMap->PMheaderID);
                printPMList();
                printf(1,"\n\n");*/

                if(tmp->PMheaderID==PMap->PMheaderID) {//happens when both point on the first link
                    if(PMap->PMprotectedPage)//if was protect_page ->update counter in proc
                        protect_page(0);
                    PMinit = PMinit->PMnext;
                }
                else {
                    //move tmp to point on PMap
                    while (tmp->PMnext->PMheaderID != PMap->PMheaderID)
                        tmp = tmp->PMnext;
//                    printf(1, "\n\nCHECKPOINT!\n\n");

                    //got here - tmp.next=PMap
                    if(PMap->PMprotectedPage)//if was protect_page ->update counter in proc
                        protect_page(0);
                    tmp->PMnext = PMap->PMnext;
                }
            }
            updateProc(2);// update proc's pagesCounter
            if (DEBUGMODE == 3)
                printf(1,">PFREE-DONE!\t");
            return 1;
        /*}
        else{
            if (DEBUGMODE == 3){
                printf(2,"PFREE-ERROR!->checkOnPM_PMap->PMadress:%d\n\n",ap);
                printPMList();
            }
            return -1;
        }*/
    }

    if (DEBUGMODE == 3)
        printf(1,">PFREE-ERROR!\t");
    return -1;
}




/*--------  old version --------------*/



/*
int
protect_page(void* ap)
{
    if (DEBUGMODE == 3)
        printf(1,"PROTECT_PAGE-\t");
    Header *p;
    if( ap )
    {
        if( (uint)ap % 4096 != 0 )
            return -1;
        p = ap;
        if (DEBUGMODE == 3)
            printf(1,">PROTECT_PAGE-DONE!\t");
        return turnOffW( p );
    }
    else{
        if (DEBUGMODE == 3)
            printf(1,">PROTECT_PAGE-ERROR!\t");
        return -1;
    }
}
*/



/*
// TODO we are not sure where we should do the page protected and read only PTE_W...
void*
pmalloc()
{
    if (DEBUGMODE == 3)
        printf(1,"PMALLOC-\t");
    Header *p, *prevp;
    uint nunits;

    nunits = ( 4096 + sizeof(Header) - 1)/sizeof(Header);
    if((prevp = freep) == 0){
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
//        printf(6,"p->s.ptr:%d\tp->s.size:%d\t\tprevp->s.ptr:%d\tprevp->s.size:%d\t\tnunits:%d\n",
//                p->s.ptr,p->s.size,prevp->s.ptr,prevp->s.size,nunits);
        if(p->s.size == nunits){
            prevp->s.ptr = p->s.ptr;
            freep = prevp;
            turnOnPM( (void *)p);
            p->s.ptr= (union header *) PGROUNDUP((uint)(p->s.ptr));
            if (DEBUGMODE == 3)
                printf(1,">PMALLOC-DONE!\t");
            printf(2,"p->s.ptr:%d\n",((uint)p->s.ptr));
            return (void*)p;
        }
        if(p == freep)
            if((p = morecore(nunits,0)) == 0){
                if (DEBUGMODE == 3)
                    printf(1,">PMALLOC-ERROR!\t");
                return 0;
            }
    }
}
*/



/*
int
pfree(void* ap) {
    if (DEBUGMODE == 3)
        printf(1,"PFREE-\t");
    Header *p;
    if (ap) {
        if (((uint)((union header *)ap)->s.ptr) % 4096 != 0) { //check that ap is align
            printf(1,"PFREE-ERROR!\n");
            printf(2,"((uint)((union header *)ap)->s.ptr):%d\n",(uint)((union header *)ap)->s.ptr);
            return -1;
        }
        p = ap;
        //check that the pm is on and W is off
        if ( checkOnPM( p ) ) {
            turnOnW(p); //turn on PTE_W
            turnOffPM(p);
            free(p); //normal free
            freep->s.ptr= freep;//TODO
            if (DEBUGMODE == 3)
                printf(1,">PFREE-DONE!\t");
            return 1;
        }
    }
    if (DEBUGMODE == 3)
        printf(1,">PFREE-ERROR!\t");
    return -1;
}
*/