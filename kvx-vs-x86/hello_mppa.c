// https://cpp.hotexamples.com/examples/-/-/_mm_add_epi16/cpp-_mm_add_epi16-function-examples.html

//#include "simde/x86/ssse3.h"
#include <emmintrin.h>
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

#ifdef __x86_64__
#include <immintrin.h>
#endif

#define IT_MAX 10
#define VECTOR_SIZE 100

//#define USE_IT_TAB

typedef int16_t int16x16_t __attribute__((__vector_size__(16*sizeof(int16_t))));
typedef int16_t int16x16_t __attribute__((__vector_size__(16*sizeof(int16_t))));


//__attribute__((aligned(16)))
#if 0
volatile struct {
  int32_t a[8];
  int32_t b[8];
  int32_t r[8];
} test_vec[VECTOR_SIZE];
#endif


#ifdef USE_IT_TAB
 struct {
  int16x16_t a[IT_MAX]; // int8x8_t((int8
  int16x16_t b[IT_MAX];
  int16x16_t r[IT_MAX];
} test_vec[VECTOR_SIZE];
#else
struct {
  int16x16_t a; // int8x8_t((int8
  int16x16_t b;
  int16x16_t r;
  int16x16_t r2; // align 64B L1 cache
} test_vec[VECTOR_SIZE];
#endif


int main()
{

  long long start_cyc, stop_cyc;;

#if defined(__KVX__) && defined(USE_PMC)
  papi_init();
#endif

  for (int it = 0; it < IT_MAX; it++) {
#if defined(__KVX__) && defined(USE_PMC)
    papi_start();
#else
    start_cyc = PAPI_get_real_cyc();
    //start_cyc = _rdtsc (void);
#endif

    //usleep(1000);

    //#pragma GCC ivdep
    #pragma GCC unroll(8)
    //#pragma omp simd
    for (size_t i = 0; i < VECTOR_SIZE ; i++) {
#if 0
      // C native version
      test_vec[i].r = test_vec[i].a + test_vec[i].b;
#else
      __m128i a = _mm_loadu_si128((void *)&test_vec[i].a);
      __m128i b = _mm_loadu_si128((void *)&test_vec[i].b);
      __m128i r = _mm_add_epi16(a, b);
      _mm_store_si128((__m128i *) &test_vec[i].r, r);
#endif

#ifdef USE_IT_TAB
      int16x16_t a = simde_mm128_loadu_epi16(&test_vec[i].a[it]);
      int16x16_t b = simde_mm128_loadu_epi16(&test_vec[i].b[it]);
      int16x16_t r = simde_mm128_add_epi16(a, b);
      test_vec[i].r[it] = r;
#else
      // int16x16


#if 0
      // builtin version
      int16x16_t a = __builtin_kvx_lhx(&test_vec[i].a, "", false);
      int16x16_t b = __builtin_kvx_lhx(&test_vec[i].b, "", false);
      int16x16_t r = __builtin_kvx_addhx(a, b, "");
      test_vec[i].r = r;
#endif

#if 0
      // manual unrolling version
      int16x16_t a = __builtin_kvx_lhx(&test_vec[2*i].a, "", false);
      int16x16_t b = __builtin_kvx_lhx(&test_vec[2*i].b, "", false);
      int16x16_t c = __builtin_kvx_lhx(&test_vec[2*i+1].a, "", false);
      int16x16_t d = __builtin_kvx_lhx(&test_vec[2*i+1].b, "", false);

      int16x16_t r1 = __builtin_kvx_addhx(a, b, "");
      int16x16_t r2 = __builtin_kvx_addhx(c, d, "");

      test_vec[2*i].r = r1;
      test_vec[2*i+1].r = r2;
#endif

      // int16x16_t r = simde_mm128_sign_epi16(a,b);
      // int16x16_t r = simde_mm128_hadd_epi16(a, b); // 160 vs 2

      // float
      // simde__m256d a = simde_mm128_loadu_pd(&test_vec_d[i].a);
      // simde__m256d b = simde_mm128_loadu_pd(&test_vec_d[i].b);
      // simde__m256d r = simde_mm128_div_pd(a, b);
      //__asm volatile("nop;;\n\t");
#endif
    }
#if defined(__KVX__) && defined(USE_PMC)
    papi_stop();
    // display only the last iteration
    papi_display(it==(IT_MAX-1)?1:0, VECTOR_SIZE);
    //papi_display(1);
#else
    stop_cyc = PAPI_get_real_cyc();
#endif
  //papi_display(true);

#ifndef USE_PMC
  printf("took %lld \n", (stop_cyc - start_cyc) / VECTOR_SIZE);
#endif
  }



  //}
#if defined(__KVX__) && defined(USE_PMC)
  papi_clean();
#endif
  return 0;
}
