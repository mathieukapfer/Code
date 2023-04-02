// https://cpp.hotexamples.com/examples/-/-/_mm_add_epi16/cpp-_mm_add_epi16-function-examples.html

//#include "simde/x86/ssse3.h"
#include <emmintrin.h>
#include <stdint.h>
#include <stdio.h>
#include <papi.h>

#include <stdbool.h>



#ifdef __x86_64__
#include <immintrin.h>
#endif

#define IT_MAX 10
#define VECTOR_SIZE 100

//#define USE_IT_TAB

typedef int16_t int16x16_t __attribute__((__vector_size__(16*sizeof(int16_t))));
typedef int16_t int16x16_t __attribute__((__vector_size__(16*sizeof(int16_t))));


struct {
  int16x16_t a; // int8x8_t((int8
  int16x16_t b;
  int16x16_t r;
  int16x16_t r2; // align 64B L1 cache
} test_vec[VECTOR_SIZE];


int main()
{

  long long start_cyc, stop_cyc;;

  for (int it = 0; it < IT_MAX; it++) {
    start_cyc = PAPI_get_real_cyc();
    //start_cyc = _rdtsc (void);

    //usleep(1000);

    //#pragma GCC ivdep
    //#pragma GCC unroll(8)
    //#pragma omp simd
    for (size_t i = 0; i < VECTOR_SIZE ; i++) {
      __m128i a = _mm_loadu_si128((void *)&test_vec[i].a);
      __m128i b = _mm_loadu_si128((void *)&test_vec[i].b);
      __m128i r = _mm_add_epi16(a, b);
      _mm_store_si128((__m128i *) &test_vec[i].r, r);

    }
    stop_cyc = PAPI_get_real_cyc();
    printf("took %lld \n", (stop_cyc - start_cyc) / VECTOR_SIZE);
  }
  return 0;
}
