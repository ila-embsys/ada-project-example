#include <kernel.h>
#include <logging/log.h>

LOG_MODULE_REGISTER(main);

extern "C" {
    extern void ada_hello();
}

void main()
{
    while (true) {
        LOG_INF("Hello World!");
        ada_hello();

        k_cpu_idle();
        k_sleep(K_MSEC(100));
    }
}
