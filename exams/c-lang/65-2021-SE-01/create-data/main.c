#include <unistd.h>
#include <err.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>


int main() {
    int fd = open("../data", O_CREAT | O_TRUNC | O_WRONLY, S_IRWXU);
    if (fd == -1) err(1, "opening file failed");

    unsigned char c = 0xB6;

    if(write(fd, &c, 1) != 1) {
        close(fd);
        err(1, "error writing to file");
    }

    exit(0);
}