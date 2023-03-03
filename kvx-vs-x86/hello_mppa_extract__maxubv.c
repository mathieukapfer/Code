//#include "simde/x86/ssse3.h"
#include <stdint.h>
#include <stdio.h>
#include <papi.h>

#include <stdbool.h>

//#include <simde/x86/avx.h>
//#include <simde/x86/avx2.h>

// ============================================================================
// Define monitoring option on mppa
//  1) display nb cycles for each iteration (overview - noisy)
//  2) display PMC counters on the last iteration (detail view - precise)

#ifdef __KVX__
// for configration 1), just comment the line below
//#define USE_PMC
#endif

// ============================================================================

#if defined(__KVX__) && defined(USE_PMC)
#include "papi_util.h"
#endif


#define IT_MAX 10

// defaut value
#ifndef VECTOR_SIZE
#define VECTOR_SIZE 100
#endif


typedef int8_t int8x32_t __attribute__((__vector_size__(32*sizeof(int8_t))));

struct {
  int8x32_t a;
  int8x32_t b;
  int8x32_t r;
  int8x32_t r2; // align 64B L1 cache
} test_vec[VECTOR_SIZE];


int main()
{

  papi_init();

  for (int it = 0; it < IT_MAX; it++) {
    papi_start();
    for (size_t i = 0; i < VECTOR_SIZE ; i++) {
      test_vec[i].r = __builtin_kvx_maxubv(test_vec[i].a,test_vec[i].b);
    }
    papi_stop();
    // display only the last iteration
    papi_display(it==(IT_MAX-1)?1:0, VECTOR_SIZE);
    //papi_display(1);
  }

  papi_clean();

  return 0;
}
