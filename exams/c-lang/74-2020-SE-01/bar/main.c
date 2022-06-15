#include <sys/types.h>
#include <sys/stat.h>
#include <stddef.h>
#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>

int main(int argc, char* argv[]) {
    if (argc != 2) errx(1, "ERROR: Incorrect number of arguments.");

    int fd = open("/tmp/fifo", O_RDONLY);
    if (fd == -1) err(1, "ERROR: opening /tmp/fifo");

    dup2(fd, 0);

    if (execl(argv[1], argv[1], (char*)NULL) == -1) {
        err(1, "ERROR: exec failed");
    }
}