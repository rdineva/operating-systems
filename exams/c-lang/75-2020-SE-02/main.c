#include <stddef.h>
#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char* argv[]) {
    if (argc != 3) errx(1, "ERROR: Incorrect number of arguments!");

    int pf[2];
    if (pipe(pf) == -1) err(1, "ERROR: pipe failed");

    int pid = fork();

    if (pid == 0) {
        close(pf[0]);
        close(1);
        dup2(pf[1], 1);

        if (execl("/bin/cat", "/bin/cat", argv[1], (char*)NULL) == -1) {
            close(pf[1]);
            err(1, "ERROR: exec failed");
        }
    }

    close(pf[1]);

    int fd = open(argv[2], O_WRONLY|O_CREAT|O_TRUNC, S_IRWXU);
    if (fd == -1) err(1, "ERROR: failed opening %s", argv[2]);

    unsigned char byte;
    int read_status;

    while((read_status = read(pf[0], &byte, 1)) > 0) {
        if (byte == 0x7D) {
            if (read(pf[0], &byte, 1) != 1) {
                close(fd);
                close(pf[0]);
                err(1, "ERROR: read failed");
            }

            byte = byte ^ 0x20; // XOR
        }

		if (byte == 0x55) continue;

        if (write(fd, &byte, 1) != 1) {
            close(fd);
            close(pf[0]);
            err(1, "ERROR: write failed");
        }
    }

    if (read_status == -1) {
        close(fd);
        close(pf[0]);
        err(1, "ERROR: read failed");
    }

    exit(0);
}
