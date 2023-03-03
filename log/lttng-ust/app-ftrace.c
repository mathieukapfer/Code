#include <stdlib.h>
#include <lttng/tracef.h>

int main(void)
{
    int i;

    for (i = 0; i < 25; i++) {
        tracef("my message: %s, this integer: %d", "a message", i);
    }

    return EXIT_SUCCESS;
}
