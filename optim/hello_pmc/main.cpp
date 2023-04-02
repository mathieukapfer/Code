
#include <stdio.h>
#include <stdlib.h>
#include <vector>


// config
// =======
#define PAPI_LOW_LEVEL
#define PAPI_HIGH_LEVEL
#define DATA_IN_STACK
//#define REVERSE


// include depend on config
#ifdef PAPI_LOW_LEVEL
#include "papi_util.h"
#elif defined PAPI_HIGH_LEVEL
#include <papi.h>
#else
#include <x86intrin.h>
#endif


void do_the_work(int *A, int *B, int *C, const int DATA_SIZE) {

  // monitoring
  long long start_cycle, stop_cycle;
#ifdef PAPI_LOW_LEVEL
  papi_start();
#elif defined PAPI_HIGH_LEVEL
  start_cycle = PAPI_get_real_cyc();
#else
  start_cycle = __rdtsc();
//#define  PAPI_REF_CYC 0x8000006b
//  start_cycle =__rdpmc(PAPI_REF_CYC);
#endif
  // the work
  for (int i = 0; i < DATA_SIZE; i++) {
    C[i]+= A[i] * B[i];
  }

  // output
#ifdef PAPI_LOW_LEVEL
  papi_stop();
  papi_display(true, DATA_SIZE);
#else
  #ifdef PAPI_HIGH_LEVEL
  stop_cycle = PAPI_get_real_cyc();
  #else
  stop_cycle = __rdtsc();
  #endif
  printf("nb cycles:%lld (%lld)\n",  (stop_cycle - start_cycle), (stop_cycle - start_cycle) / DATA_SIZE);
#endif
}



int main(int argc, char *argv[])
{
  const int NB_ITER = 3;

#ifdef PAPI_LOW_LEVEL
  papi_init();
#endif

  std::vector<int> datasizes = {1,2,5,10,20,50,100,200,500,1000,2000,5000,10000,20000,50000,100000,200000};

#ifdef REVERSE
  for (auto it=datasizes.rbegin(); it !=datasizes.rend(); it++) {
    int data_size=*it;
#else
  for (int data_size : datasizes) {
#endif
    printf("datasize:%d\n", data_size);

#ifdef DATA_IN_STACK
    int A[data_size]; int B[data_size]; int C[data_size];
#else
    int *A, *B, *C;
    A = (int *) malloc(data_size * sizeof(int));
    B = (int *) malloc(data_size * sizeof(int));
    C = (int *) malloc(data_size * sizeof(int));
#endif

    //
    for (int it = 0; it < NB_ITER; it++) {
      do_the_work(A, B, C, data_size);
    }

#ifdef DATA_IN_STACK
#else
    free(A);
    free(B);
    free(C);
#endif
    }

#ifdef PAPI_LOW_LEVEL
  papi_clean();
#endif

}
