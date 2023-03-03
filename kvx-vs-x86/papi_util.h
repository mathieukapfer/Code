#include <papi.h>

// option
#define PAPI_LOW_LEVEL


// process option
#ifdef PAPI_LOW_LEVEL
#define MAX_PAPI_EVENT 4
#define PMC_1 PCC
#define PMC_2 EBE
#define PMC_3 DARSC
#define PMC_4 FSC
//#define PMC_4 DCLME
#include <mppa_cos.h>
#else
#define MAX_PAPI_EVENT 2
const char *pmc_name[MAX_PAPI_EVENT] = {"PCC", "EBE"};
long long papi_data[MAX_PAPI_EVENT];
int papi_evenSet = PAPI_NULL;
long long papi_data[] =  {0};
#endif

void papi_init() {
#ifdef PAPI_LOW_LEVEL
  __cos_counter_stop_all();
  __cos_counter_reset_all();
#else
  int ret;

  /* PAPI library initialization */
  ret = PAPI_library_init(PAPI_VER_CURRENT);
  if (ret != PAPI_VER_CURRENT) {
    printf("Failed to PAPI_init\n");
  }

  ret = PAPI_create_eventset(&papi_evenSet);
  if (ret != PAPI_OK) {
    printf("Failed to PAPI_create_eventset\n");
  }

  for (int index=0; index < MAX_PAPI_EVENT; index++) {
    ret = PAPI_add_named_event(papi_evenSet, pmc_name[index]);
    if (ret != PAPI_OK) {
      printf("Failed to PAPI_add_named_event(%s)\n", pmc_name[index]);
    }
  }
#endif
}

static inline void papi_start() {
#ifdef PAPI_LOW_LEVEL
#define CAT2(a,b) a ## b
#define CAT(a,b) CAT2(a, b)
  __cos_counter_start_all(CAT(_COS_PM_, PMC_1), CAT(_COS_PM_, PMC_2), CAT(_COS_PM_, PMC_3), CAT(_COS_PM_, PMC_4));
#else

 int ret;

  ret = PAPI_reset(papi_evenSet);
  if (ret != PAPI_OK) {
    printf("Failed to PAPI_reset\n");
  }

  ret = PAPI_start(papi_evenSet);
  if (ret != PAPI_OK) {
    printf("Failed to PAPI_start\n");
  }
#endif
}

static inline void papi_stop() {
#ifdef PAPI_LOW_LEVEL
  __cos_counter_stop_all();
#else
  long long ret = PAPI_stop(papi_evenSet, papi_data);
  if (ret != PAPI_OK) {
    printf("Failed to PAPI_stop\n");
  }
#endif
}


void papi_clean() {
#ifdef PAPI_LOW_LEVEL
#else
  PAPI_cleanup_eventset(papi_evenSet);
  PAPI_destroy_eventset(&papi_evenSet);
#endif
}

void papi_display(bool display, int ratio) {
#ifdef PAPI_LOW_LEVEL

  static long long previous[MAX_PAPI_EVENT] = { 0 };

  // Build table of PMC's name
  //  - convert pmc name to char
#define PMC_NAME(pmc1, pmc2, pmc3, pmc4)                          \
  static const char *PMC_NAME[] ={ #pmc1, #pmc2, #pmc3, #pmc4 };
  //  - expend pmc name
#define PMC_NAME_(a,b,c,d)  PMC_NAME(a,b,c,d)
  //  - declare the magic table
  PMC_NAME_(PMC_1, PMC_2, PMC_3, PMC_4);

  long long delta[MAX_PAPI_EVENT] = { 0 };
  for (int index=0; index < MAX_PAPI_EVENT; index++) {
    delta[index] = __cos_counter_num(index) - previous[index];
    if(display) {
      printf("%6s:%6lu delta:%6lld once: %0.2f (size:%d)\n", PMC_NAME[index] , __cos_counter_num(index), delta[index], (float)delta[index]/ratio, ratio );
    }
    previous[index] =__cos_counter_num(index);
  }
#else
  for (int index=0; index < MAX_PAPI_EVENT; index++) {
    printf("%s %lld\n", pmc_name[index], papi_data[index]);
  }
#endif
}
