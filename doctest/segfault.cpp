#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include "doctest.h"

int my_div(int a, int b) { return a / b ; }

TEST_CASE("testing div function") {
  CHECK(my_div(1,1) == 1);
  CHECK(my_div(1,0) == 1);
}
