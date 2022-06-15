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
    if (argc != 3) errx(1, "ERROR: 2 file arguments needed!");

    int fd1 = open(argv[1], O_RDONLY);
    if (fd1 == -1) err(1, "ERROR: opening from %s", argv[1]);

    int fd2 = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, S_IRWXU);
    if (fd2 == -1) err(1, "ERROR: opening from %s", argv[2]);

    unsigned char buff;
    ssize_t read_size;

    unsigned char byte = 0;
    int bit_index = CHAR_BIT - 1;

    while((read_size = read(fd1, &buff, sizeof(unsigned char)))) {
        if (read_size == -1) {
            close(fd1);
            close(fd2);
            err(1, "ERROR: reading %s", argv[1]);
        }

        for(int i = CHAR_BIT - 1; i >= 0; i-=2) {
            int bit = (buff>>i)&1;

            byte |= bit << bit_index;
            bit_index--;
            printf("%d\n", byte);
        }

        if (bit_index <= 0) {
            if (write(fd2, &byte, sizeof(unsigned char)) == -1) {
                close(fd1);
                close(fd2);
                err(1, "ERROR: writing to file");
            }

            byte = 0;
            bit_index = CHAR_BIT - 1;
        }
    }

    close(fd1);
    close(fd2);
    exit(0);
}