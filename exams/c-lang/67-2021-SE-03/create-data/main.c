#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <err.h>

int main() {
    uint16_t numbers[7];
    numbers[0] = 0x0001;
    numbers[1] = 0x0017;
    numbers[2] = 0x0038;
    numbers[3] = 0x000D;
    numbers[4] = 0x0005;
    numbers[5] = 0x005A;
    numbers[6] = 0x000A;

    int fd = open("../data", O_CREAT | O_TRUNC | O_WRONLY, S_IRWXU);
    if (write(fd, numbers, 14) == -1) {
        close(fd);
        err(1, "err");
    }

    exit(0);
}