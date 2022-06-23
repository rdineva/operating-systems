#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <err.h>
#include <unistd.h>

int main() {
    int fd = open("../data", O_WRONLY | O_CREAT | O_TRUNC, S_IRWXU);
    if (fd == -1) err(1, "ERROR: opening file failed");

    unsigned char data[15];

    data[0] = 0x7D;
    data[1] = ((unsigned char)0x00) ^ 0x20;
    data[2] = 0x01;
    data[3] = 0x02;
    data[4] = 0x7D;
    data[5] = 0xFF ^ 0x20;
    data[6] = 0x03;
    data[7] = 0x04;
    data[8] = 0x7D;
    data[9] = 0x55 ^ 0x20;
    data[10] = 0x05;
    data[11] = 0x06;
    data[12] = 0x7D;
    data[13] = 0x7D ^ 0x20;
    data[14] = 0x07;

    if(write(fd, data, 15) != 15) {
        close(fd);
        err(1, "ERROR: writing to file failed");
    }

    exit(0);
}
