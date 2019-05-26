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

void
free(void *ap)
{
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
}

static Header*
morecore(uint nu, int notFromPmalloc)
{
  char *p;
  Header *hp;
//notFromPmalloc- because in this specific func there is a need for smaller sbrk
  if(nu < 4096 && notFromPmalloc)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
  return freep;
}

void*
malloc(uint nbytes)
{
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
            return (void*)(p + 1);
        }
        if(p == freep)
            if((p = morecore(nunits,1)) == 0)
                return 0;
    }
}


// TODO we are not sure where we should do the page protected and read only PTE_W...

void*
pmalloc()
{
    Header *p, *prevp;
    uint nunits;
    //const uint mask= 4096;

    nunits = ( 4096 + sizeof(Header) - 1)/sizeof(Header) + 1;
    nunits--;
    if((prevp = freep) == 0){
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
        if(p->s.size == nunits){
            prevp->s.ptr = p->s.ptr;
            freep = prevp;
            p->x = 1; //TODO?
            turnOnPM( (void *)( p + 1 ) );
            p->s.ptr= (union header *) PGROUNDUP((uint)(p->s.ptr));
            return (void*)p;
        }
        if(p == freep)
            if((p = morecore(nunits,0)) == 0)
                return 0;
    }
}


int
protect_page(void* ap)
{
    Header *p;
    if( ap )
    {
        if( (uint)ap % 4096 != 0 )
            return -1;
        p = ap;
        return turnOffW( p );
    }
    else
        return -1;
}



int
pfree(void* ap) {
    Header *p;
    if (ap) {
        if ((uint) ap % 4096 != 0) //check that ap is align
            return -1;
        p = ap;
        //check that the pm is on and W is off
        if ( checkOnPM( p ) ) {
            turnOnW(p); //turn on PTE_W
            free(ap); //normal free
            return 1;
        }
    }
    return -1;
}


