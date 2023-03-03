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
#define VECTOR_SIZE 100


typedef int16_t int16x32_t __attribute__((__vector_size__(16*sizeof(int16_t))));

struct {
  int16x32_t a; // int8x8_t((int8
  int16x32_t b;
  int16x32_t r;
  int16x32_t r2; // align 64B L1 cache
} test_vec[VECTOR_SIZE];



for (size_t i = 0; i < VECTOR_SIZE ; i++) {
  test_vec[i].r = test_vec[i].a + test_vec[i].b;
