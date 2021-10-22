#include <stdio.h>
#include <inttypes.h>
#include <stdint.h>
#include <emmintrin.h>
#include <xmmintrin.h>
#include <string.h>


#define simd_q15_t __m128i
#define simdshort_q15_t __m64
#define shiftright_int16(a,shift) _mm_srai_epi16(a,shift)
#define set1_int16(a) _mm_set1_epi16(a)
#define mulhi_int16(a,b) _mm_slli_epi16(_mm_mulhi_epi16(a,b),1)
#define mulhi_s1_int16(a,b) _mm_slli_epi16(_mm_mulhi_epi16(a,b),2)
#define adds_int16(a,b) _mm_adds_epi16(a,b)
#define mullo_int16(a,b) _mm_mullo_epi16(a,b)

// y+= a*x
// all value in q15 format
void multadd_real_vector_complex_scalar(int16_t *x,     // real vector
                                        int16_t *alpha, // complex scalar (r,i)
                                        int16_t *y,     // vector complex (r,i,r,i,..)
                                        uint32_t N)     // size of vector
{
  uint32_t i;

  // do 8 multiplications at a time
  simd_q15_t alpha_r_128,alpha_i_128,yr,yi,*x_128=(simd_q15_t*)x,*y_128=(simd_q15_t*)y;
  int j;

  alpha_r_128 = set1_int16(alpha[0]);
  alpha_i_128 = set1_int16(alpha[1]);

  j=0;

  for (i=0; i<N>>3; i++) {

    /* FIXED: replace mulhi_s1_int16 by mulhi_int16 !!!! */
    yr     = mulhi_int16(alpha_r_128,x_128[i]);
    yi     = mulhi_int16(alpha_i_128,x_128[i]);

#if 0
    for (int i=0; i<8; i++) {
      int16_t *yr_, *yi_;
      yr_ = (int16_t *)&yr;
      yi_ = (int16_t *)&yi;

      printf("\n");
      printf("yr[%d]: 0x%x + 0x%x x 0x%x = 0x%x \n", i, y[2*i], x[i], alpha[0], yr_[i] );
      printf("yr[%d]: %f + %f x %f = %f \n", i,
             (float) y[2*i] / ( 1 << 15),
             (float)x[i] / ( 1 << 15),
             (float)alpha[0] / ( 1 << 15),
             (float)yr_[i] / ( 1 << 15) );
      printf("yi[%d]: 0x%x + 0x%x x 0x%x = 0x%x \n", i, y[2*i+1], x[i], alpha[1], yi_[i] );
      printf("yi[%d]: %f + %f x %f = %f \n", i,
             (float) y[2*i+1] / ( 1 << 15),
             (float)x[i] / ( 1 << 15),
             (float)alpha[1] / ( 1 << 15),
             (float)yi_[i] / ( 1 << 15) );
    }
#endif

    y_128[j] = _mm_adds_epi16(y_128[j],_mm_unpacklo_epi16(yr,yi));
    j++;
    y_128[j] = _mm_adds_epi16(y_128[j],_mm_unpackhi_epi16(yr,yi));
    j++;

  }

  _mm_empty();
  _m_empty();

};

// q15
__m128i multhi(int16_t *x, int16_t *y) {
  __m128i *vx = (__m128i *)x;
  __m128i *vy = (__m128i *)y;
  __m128i vr;
  int16_t *r = (int16_t *)&vr;

  vr = _mm_mulhi_epi16(*vx,*vy); // remove 16 bits => too much
  vr =_mm_slli_epi16(vr, 1); //  << 1 to restore 15 bits

  for (int i=0; i<8; i++) {
    printf("\n");
    printf("0x%x x 0x%x = 0x%x\n", x[i], y[i], r[i]);
    printf("%d x %d = %d \n", x[i], y[i], r[i]);
    printf("%f x %f = %f \n", (float)x[i]/(1<<15), (float)y[i]/(1<<15), (float)r[i]/(1<<15));
  }

  return vr;
}

// The Q15 is a popular format in which the most significant bit is the sign bit, followed by 15 bits of fraction. The Q15 number has a decimal range between –1 and 0.9999 (0x8000 to 0x7FFF). This Q-value specifies how many binary digits are allocated for the fractional portion of the number.

#define SIZE_VECTOR 8

int main(int argc, char *argv[])
{
  int16_t x[SIZE_VECTOR];
  int16_t a[2] = { 0x4000 /*R: 0,5*/, 0x2000 /*I: 0,25*/};
  int16_t y[SIZE_VECTOR*2];
  int16_t y_in[SIZE_VECTOR*2];

#if 1

  // fill input
  for(int i=0; i< 8; i++) {
    x[i] =  0x8000  >> i;  // R: -1, 0.5, 0.25, 0.125, ...
    y[i] =   0x100  << i;  // R: 0.007812, I:0.015625, R:0.031250, I:0.062500, R:0.125000, I:0.250000, ...
    y[i+8] = 0x100  << i;
  }

  // keep y
  memcpy(y_in, y, sizeof(int16_t) * SIZE_VECTOR * 2);

  multadd_real_vector_complex_scalar(x, a, y, 8);

  for (int i=0; i<8; i++) {
    printf("\n");
    //printf("R[%d]: 0x%x += 0x%x x 0x%x = 0x%x \n",  i, y_in[i*2], x[i], a[0], y[i]);
    printf("R[%d]: %f += %f x %f = %f \n", i,
           (float) y_in[i*2] / ( 1 << 15),
           (float) x[i] / ( 1 << 15) ,
           (float) a[0] / ( 1 << 15),
           (float) y[i*2] / ( 1 << 15));
    //printf("I[%d]: 0x%x += 0x%x x 0x%x = 0x%x \n",  i, y_in[i*2+1], x[i], a[1], y[i+1]);
    printf("I[%d]: %f += %f x %f = %f \n", i,
           (float) y_in[i*2+1] / ( 1 << 15),
           (float) x[i] / ( 1 << 15) ,
           (float) a[1] / ( 1 << 15),
           (float) y[i*2+1] / ( 1 << 15));
  }


#else
  __m128i vr, vr1, vr2, vr3;
  int16_t *r = (int16_t *)&vr;
  int16_t *r1 = (int16_t *)&vr1;
  int16_t *r2 = (int16_t *)&vr2;
  int16_t *r3 = (int16_t *)&vr3;

  int16_t x1[SIZE_VECTOR];
  int16_t y1[SIZE_VECTOR];

  for(int i=0; i< 8; i++) {
    y1[i] =  0x8000  >> i;     // -1, 0.5, 0.25, 0.125, ...
    x1[i] =  0x8000  >> (i/2); // -1, -1, 0.5, 0.5, 0,25, 0,25, ...
  }

  // test mul
  vr = multhi(x1,y1);

  // test shift left
  printf("\nshift left:\n");
  vr1 =_mm_slli_epi16(vr, 1);
  for (int i=0; i<8; i++) {
    printf("%x => %x\n", r[i], r1[i]);
  }

  // test add
  int16_t c[] = { 1,2,3,4,5,6,7,8};
  __m128i *vc = (__m128i *) &c;

  vr2 = _mm_adds_epi16(vr1, *vc);
  printf("\nadd:\n");
  for (int i=0; i<8; i++) {
    printf("%x = %x + %x\n", r2[i], r1[i], c[i]);
  }

  // test unpackhi
  int16_t a4[] = { 1, 2 , 3, 4, 5, 6, 7, 8};
  int16_t a5[] = { 0x10, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70, 0x80};
  int16_t r6[] = { 0, 0, 0, 0, 0, 0, 0, 0 };

  __m128i *va4, *va5, *vr6;
  va4 = (__m128i *)&a4;
  va5 = (__m128i *)&a5;
  vr6 = (__m128i *)&r6;

  printf("\nunpack low:\n");
  *vr6 = _mm_unpacklo_epi16(*va4, *va5);
  for (int i=0, j=0; i<4; i++, j+=2) {
    printf("%x %x = %x , %x\n", r6[j], r6[j+1], a4[i], a5[i]);
  }

  printf("\nunpack high:\n");
  *vr6 = _mm_unpackhi_epi16(*va4, *va5);
  for (int i=4, j=0; i<8; i++, j+=2) {
    printf("%x %x = %x , %x\n", r6[j], r6[j+1], a4[i], a5[i]);
  }


#endif

  return 0;
}
