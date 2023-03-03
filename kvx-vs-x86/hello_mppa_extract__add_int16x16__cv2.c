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


#define IT_MAX 3

// defaut value
#ifndef VECTOR_SIZE
#define VECTOR_SIZE 130 // 130
#endif

// #define ENABLE_CIRCULAR_BUFFER

typedef int16_t int16x16_t __attribute__((__vector_size__(16*sizeof(int16_t))));

// decare buffer
int16x16_t a_[VECTOR_SIZE];
int16x16_t b_[VECTOR_SIZE];
int16x16_t r_[VECTOR_SIZE];

// Number of TCA registers used for each circular buffer
#define TCA_BUF_LENGTH (16)
#define TCA_BUF_X    "a0..a15"
#define TCA_BUF_X_0  "a0"

#define TCA_BUF_Y    "a16..a31"
#define TCA_BUF_Y_0  "a16"

int main()
{

  // declare pointers
  int16x16_t *restrict a = a_;
  int16x16_t *restrict b = b_;
  int16x16_t *restrict r = r_;

  // fill
  for (size_t i = 0; i < VECTOR_SIZE ; i++) {
    for (int elem = 0; elem < 16; elem++) {
      a_[i][elem] = i*elem;
      b_[i][elem] = i*elem+1;
      r_[i][elem] += 1;
    }
  }

  papi_init();

  for (int it = 0; it < IT_MAX; it++) {
    papi_start();

#ifdef ENABLE_CIRCULAR_BUFFER
    // heads to push/pop to/from circular buffers
    uint64_t head_push = 0;
    uint64_t head_pop  = 0;

    __kvx_x4096 xbuf_a = __builtin_kvx_xundef4096(); // avoid uninitialized warning
    __kvx_x4096 xbuf_b = __builtin_kvx_xundef4096(); // avoid uninitialized warning

    // Prolog: fill TCA_BUF_LENGTH slots of each buffer
    for (int i = 0; i < TCA_BUF_LENGTH; ++i) {
      xbuf_a = __builtin_kvx_xpreload4096(xbuf_a, a, head_push, ".us"); a ++;
      xbuf_b = __builtin_kvx_xpreload4096(xbuf_b, b, head_push, ".us"); b ++;
      head_push += 16*sizeof(int16_t);
    }
#endif

    // Compute loop
    for (size_t i = 0; i < VECTOR_SIZE ; i++) {
#ifdef ENABLE_CIRCULAR_BUFFER
      int16x16_t a0 = __builtin_kvx_xaccess4096o(xbuf_a, head_pop);
      int16x16_t b0 = __builtin_kvx_xaccess4096o(xbuf_b, head_pop);
      head_pop += 16*sizeof(int16_t);
      // preload
      xbuf_a = __builtin_kvx_xpreload4096(xbuf_a, a, head_push, ".us"); a ++;
      xbuf_b = __builtin_kvx_xpreload4096(xbuf_b, b, head_push, ".us"); b ++;
      head_push += 16*sizeof(int16_t);
      //
      //printf("pop:%d, push:%d \n", head_pop, head_push);
      // compute
      r[i] = a0 + b0;
#else
      r[i] = a[i] + b[i];
#endif
    }

    papi_stop();
    // display only the last iteration
    papi_display(true /*it==(IT_MAX-1)?1:0*/, VECTOR_SIZE);
    //papi_display(1);

#if 1
   a = a_;
   b = b_;

    // check
    for (size_t i = 0; i < VECTOR_SIZE ; i++) {
      for (int elem = 0; elem < 16; elem++) {
        if(r[i][elem] != a[i][elem] + b[i][elem]) {
          printf("%ld[%d] KO: %d != %d + %d, \n", i, elem, r[i][elem], a[i][elem], b[i][elem]);
        }
        //printf("%ld[%d]: %d == %d + %d, \n", i, elem, r[i][elem], a[i][elem], b[i][elem]);
      }
    }
#endif
  }


  papi_clean();

  return 0;
}
