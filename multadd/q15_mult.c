#include <stdio.h>
#include <stdint.h>

#define Q 15

// precomputed value:
#define K   (1 << (Q - 1))

// saturate to range of int16_t
int16_t sat16(int32_t x)
{
	if (x > 0x7FFF) return 0x7FFF;
	else if (x < -0x8000) return -0x8000;
	else return (int16_t)x;
}

int16_t q_mul(int16_t a, int16_t b)
{
    int16_t result;
    int32_t temp;

    temp = (int32_t)a * (int32_t)b; // result type is operand's type
    // Rounding; mid values are rounded up
    temp += K;
    // Correct by dividing by base and saturate result
    result = sat16(temp >> Q);

    return result;
}

int main(int argc, char *argv[])
{
  // test  0.5 * 0.5
  int32_t a = 0x4000 /* = 0,5 in q15*/;
  int32_t b = 0x4000 /* = 0,5 in q15*/;
  int32_t r_expected = 0x2000 /* = 0,25 in q15*/;

  printf("0x%x x 0x%x = 0x%x [expected 0x%x]\n", a, b, q_mul(a,b), r_expected );
  printf("%f x %f = %f [expected 0x%x]\n", (float)a / (1<<Q), (float)a / (1<<Q), (float) q_mul(a,b) / (1<<Q), r_expected );
  return 0;
}
