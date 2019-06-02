#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"

#define PGSIZE 4096

/********** 2.1 tests  **********/
int validation_check(void *a, int PMALLOCFLAG){
    //validation checks
    if (!a) {
        if(PMALLOCFLAG)
            printf(1, "ERROR in test_1_1 -> pmalloc returned addres 0!\n");
        return 0;
    }
    if ((int) a % 4096 != 0) {
        if(PMALLOCFLAG)
            printf(1, "ERROR in test_1_1 -> pmalloc returned not aligned addres!\n");
        return 0;
    }
    if (!checkOnPM(a)) {
        if(PMALLOCFLAG)
            printf(1, "ERROR in test_1_1 -> pmalloc not FLAGed PTE_PM & PTE_W!\n");
        return 0;
    }
    return 1;
}

int protect_page_test(void* a){
    return protect_page(a);
}

//test PMALLOC , PROTECT PAGE and PFREE
int test_1_1(void) {
    /**********
     * This test Pmalloc, protect and Pfree 5 times in a row
     * **********/
    void *a=0, *b=0, *c=0, *d=0, *e=0;
    void *arr[] = {a, b, c, d, e}; //array of pointers to pmallocs
    int i = 0;
    //PMALLOC
    for (; i < 5; i++) { //pmalloc each pointer
        arr[i]=pmalloc();
        if(!validation_check(arr[i],1))
            return 0;
    }

    //PROTECT PAGE
    for (i=0; i < 5; i++) { //protect each pointer
        if (protect_page_test(arr[i]) != 1) //if got failed in one of the checks - test failed
            return 0;
    }

    //PFREE
    for (i=0; i < 5; i++) { //pfree each pointer
        if(!validation_check(arr[i],1))
            return 0;
        if(pfree(arr[i]) != 1)
            return 0;
    }

    return 1;
}

//test fork, exec and exit
int test_1_2(void) {
    /**********
     * pm =PMALLOC ; m=MALLOC
     * This test run allocation,protect and free on arr=[pm,pm,pm,m,m,m]
     * **********/
    void *a=0, *b=0, *c=0, *d=0, *e=0 ,*f=0;
    void *arr[] = {a, b, c, d, e, f}; //array of pointers to pmallocs
    int i = 0;
    //PMALLOC 0-2
    for (; i < 3; i++) { //pmalloc each pointer
        arr[i]=pmalloc();
        if(!validation_check(arr[i],1))
            return 0;
    }
    //MALLOC 3-6
    for (; i < 6; i++) { //pmalloc each pointer
        arr[i]=malloc(4096);
        //this time- should not pass the validation
        // test because it test pmalloc
        if(validation_check(arr[i],0))
            return 0;
    }
    //PROTECT PAGE
    for (i=0; i < 3; i++) { //protect each pointer
        if (protect_page_test(arr[i]) != 1) //if got failed in one of the checks - test failed
            return 0;
    }
    //PROTECT PAGE
    for (; i < 6; i++) { //protect each pointer
        //this time- should not pass the validation
        // test because it test pmalloc
        if (protect_page_test(arr[i]) == 1)
            return 0;
    }

    //PFREE
    for (i=0; i < 6; i++) { //pfree each pointer
        if(i<3) { //if PMALLOC
            if (!validation_check(arr[i],1))
                return 0;
            if (pfree(arr[i]) != 1)
                return 0;
        }
        else{//if MALLOC
            //should try and fail in PFREE
            if (pfree(arr[i]) == 1)
                return 0;
            free(arr[i]);
        }
    }


    return 1;
}

/********** 2.2 tests  **********/



int test_21(void) {
    /**********
     * big malloc , memset this block and free it
     * **********/
    void *a=malloc(10*PGSIZE);
    void *b=pmalloc();
    memset(a,5,10*PGSIZE);
    free(a);
    pfree(b);

    return 1;
}

/***************  main  ***************/


void run_test(int testNum) {
    switch (testNum) {
        case 11:
            printf(1, "-- Start test 1.1 --\n");
            if (test_1_1())
                printf(1, "-- Test 1.1 Passed! --\n");
            else
                printf(1, "-- Failed in test 1.1 --\n");
            break;
        case 12:
            printf(1, "-- Start test 1.2 --\n");
            sleep(250);
            if(test_1_2())
                printf(1, "-- Test 1.2 Passed! --\n");
            else
                printf(1, "-- Failed in test 1.2 --\n");
            break;
        case 21:
            printf(1, "-- Start test 2.1 --\n");
            if(test_21())
                printf(1, "-- Test 2.1 Passed! --\n");
            else
                printf(1, "-- Failed in test 2.1 --\n");
            break;
        default:
            printf(2, "ERROR- wrong test_ID %d \n\n", testNum);
            return;
    }
}

int main(int argc, char *argv[]) {
    run_test(11); //Test to part 1 - pmalloc, protected and pfree
    run_test(12);//Test for part 1 - pmalloc, protected,pfree,malloc and free
    run_test(21);//Test for part 2 - Paging framework

    exit();
}