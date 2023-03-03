#include <syslog.h>

char        logTxt[]="test";

int main(int argc, char **argv) {
        openlog(logTxt, LOG_CONS|LOG_PID, LOG_LOCAL7);
        syslog(LOG_DEBUG, "Ceci est un essai...");
        closelog();
        return 0;
}
