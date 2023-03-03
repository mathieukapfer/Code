#include <stdlib.h>
#include <lttng/tracelog.h>

int main(int argc, char *argv[])
{
    int i;

    if (argc < 2) {
        tracelog(TRACE_CRIT, "Not enough arguments: %d", argc);
        return EXIT_FAILURE;
    }

    tracelog(TRACE_INFO, "Starting app with %d arguments", argc);

    for (i = 0; i < argc; i++) {
        tracelog(TRACE_DEBUG, "Argument %d: %s", i, argv[i]);
    }

    tracelog(TRACE_INFO, "Exiting app");

    return EXIT_SUCCESS;
}
