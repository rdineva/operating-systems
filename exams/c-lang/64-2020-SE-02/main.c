#include <err.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <limits.h>


int main(int argc, char* argv[]) {
    if (argc != 3) errx(1, "3 args needed!");

    // scl file
    int fd1 = open(argv[1], O_RDONLY);
    if (fd1 == -1) err(1, "err opening %s", argv[2]);

    // sdl file
    int fd2 = open(argv[2], O_RDONLY);
    if (fd1 == -1) {
        close(fd1);
        err(1, "err opening %s", argv[2]);
    }

    int fd3 = open("result.sdl", O_CREAT | O_TRUNC | O_WRONLY, S_IRWXU);
    if (fd1 == -1) {
        close(fd1);
        close(fd2);
        err(1, "err opening result.sdl");
    }

	unsigned char volumes = 0;
    uint16_t signal;
    int read_size;

    while((read_size = read(fd1, &volumes, sizeof(unsigned char)))) {
        if (read_size != sizeof(unsigned char)) {
            close(fd1);
            close(fd2);
            close(fd3);
            err(1, "err reading signal %d", volumes);
        }

        for(int i = CHAR_BIT - 1; i >= 0; i--) {
            if (read(fd2, &signal, sizeof(uint16_t)) == -1) {
                close(fd1);
                close(fd2);
                close(fd3);
                err(1, "error reading volumes %d", signal);
            }

            int volume_bit = (volumes>>i)&1;
            printf("%d", volume_bit);

            if (volume_bit == 1 && write(fd3, &signal, sizeof(uint16_t)) == -1) {
                close(fd1);
                close(fd2);
                close(fd3);
                err(1, "err");
            }
        }
    }

    close(fd1);
    close(fd2);
    close(fd3);
    exit(0);
}

