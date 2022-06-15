#include <sys/types.h>
#include <sys/stat.h>
#include <stddef.h>
#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>

int main(int argc, char* argv[]) {
    if (argc != 2) errx(1, "ERROR: Incorrect number of arguments.");

    int fifo_status = mkfifo("/tmp/fifo", S_IRUSR | S_IWUSR);
    if (fifo_status == -1) err(1, "ERROR: Fifo creation failed");

    int fd = open("/tmp/fifo", O_WRONLY);
    if (fd == -1) err(1, "ERROR: couldn't open /tmp/fifo file");

    dup2(fd, 1);

    if (-1 == execl("/bin/cat", "/bin/cat", argv[1], (char *)NULL)) {
        err(1, "ERROR: couldn't exec");
    }
}