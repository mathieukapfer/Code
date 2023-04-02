#include <papi.h>
#include <papiStdEventDefs.h>
#include <stdio.h>


// process option
#define MAX_PAPI_EVENT 3

static const char *pmc_name[MAX_PAPI_EVENT] = {"PAPI_L1_DCM", "PAPI_TOT_CYC", "PAPI_TOT_INS"};
static const  int pmc_event[MAX_PAPI_EVENT] = {PAPI_L1_DCM, PAPI_TOT_CYC, PAPI_TOT_INS};
static long long papi_data[MAX_PAPI_EVENT] = {0};
static int papi_evenSet = PAPI_NULL;

inline void papi_init() {
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
    ret = PAPI_add_event(papi_evenSet, pmc_event[index]);
    if (ret != PAPI_OK) {
      printf("Failed to PAPI_add_named_event(%s)\n", pmc_name[index]);
    }
  }
}

inline void papi_start() {
  PAPI_reset(papi_evenSet);
  PAPI_start(papi_evenSet);
}

inline void papi_stop() {
  PAPI_stop(papi_evenSet, papi_data);
}

inline void papi_clean() {
  PAPI_cleanup_eventset(papi_evenSet);
  PAPI_destroy_eventset(&papi_evenSet);
}

inline void papi_display(bool display, int ratio) {
  for (int index=0; index < MAX_PAPI_EVENT; index++) {
    printf("%s %3lld (%3lld) ", pmc_name[index], papi_data[index], papi_data[index]/ratio);
  }
  printf("\n");
}
