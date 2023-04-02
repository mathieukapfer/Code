# install
sudo apt install libpapi-dev

Note:
Accessing performance counters from userspace may require reducing the paranoia
level in /proc/sys/kernel/perf_event_paranoid, see README.Debian for details.

# make
make clean all
