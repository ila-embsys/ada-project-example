#include <kernel.h>
#include <logging/log.h>

LOG_MODULE_REGISTER(main);

extern "C" {
    extern void ada_hello();
}

void main()
{
    LOG_INF("Start Ada execution!");
    ada_hello();
}
