// https://gcc.gnu.org/onlinedocs/gcc-4.6.1/gcc/Vector-Extensions.html#Vector-Extensions

#include <stdio.h>

#define RESTRICT // restrict
#define BASE_TYPE float

void loop(int N, const BASE_TYPE * RESTRICT a,
                 const BASE_TYPE * RESTRICT b,
                 BASE_TYPE * RESTRICT c)
{
    for (int i = 0; i < N; i++)
    {
        c[i] += a[i] * b[i];
        //printf("%f = %f * %f \n", c[i],a[i],b[i]);
    }
}

#define VECTOR_SIZE 16
typedef BASE_TYPE vsf __attribute__((vector_size(VECTOR_SIZE * sizeof(BASE_TYPE))));

void loopv(int N, BASE_TYPE * a, BASE_TYPE* b, BASE_TYPE * c)
{
    for (int i = 0; i < N ; i += VECTOR_SIZE)
    {
        vsf * c_v = (vsf *)&c[i];
        vsf * a_v = (vsf *)&a[i];
        vsf * b_v = (vsf *)&b[i];

        *c_v += *a_v * *b_v;
    }
}


#define DATA_SIZE 32
int main(int argc, char *argv[])
{

  BASE_TYPE a[DATA_SIZE];
  BASE_TYPE b[DATA_SIZE];
  BASE_TYPE c[DATA_SIZE];

  // init
  for (int i=0; i < DATA_SIZE; ++i) {
    a[i] = i;
    b[i] = 1;
    c[i] = 1;
  }

  // call standard loop
  loop(DATA_SIZE, a, b, c);

  // display
  printf("\n loop :");
  for (int i=0; i < DATA_SIZE; ++i) {
    printf("%f ", c[i]);
    c[i] = 1; // reinit
  }

  // call vectorized loop
  loopv(DATA_SIZE, a, b, c);

  // display
  printf("\n loopv:");
  for (int i=0; i < DATA_SIZE; ++i) {
    printf("%f ", c[i]);
  }

  return 0;
}
