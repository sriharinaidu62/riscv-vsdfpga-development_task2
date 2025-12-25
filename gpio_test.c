#include "io.h"

#define GPIO_BASE 0x20000000

volatile unsigned int *gpio = (unsigned int *)GPIO_BASE;

int main() {
    unsigned int val;

    *gpio = 0xA5A5A5A5;
    val = *gpio;

    print_hex(val);
    putchar('\n');   // <-- ALWAYS exists

    while (1);
}
