#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <err.h>
#include <stdio.h>

void close_with_error(int fd1, int fd2) {
    close(fd1);
    close(fd2);
    err(1, "err");
}

int main(int argc, char* argv[]) {
    if (argc != 3) errx(1, "ERROR: 3 arguments needed");

    int fd1 = open(argv[1], O_RDONLY);
    if (fd1 == -1) err(1, "ERROR: couldnt open %s", argv[1]);

    int fd2 = open(argv[2], O_CREAT | O_TRUNC | O_WRONLY, S_IRWXU);
    if (fd2 == -1) {
        close(fd1);
        err(1, "ERROR: couldnt open %s", argv[2]);
    }

    char start_array[] = "#include <stdint.h>\nuint16_t arr[] = {";
    if (write(fd2, &start_array, 38) != 38) {
        close_with_error(fd1, fd2);
    }

    uint16_t number;
    ssize_t read_status;
    int count = 0;

    while((read_status = read(fd1, &number, sizeof(uint16_t)))) {
        if (read_status == -1) close_with_error(fd1, fd2);

        if (count != 0) {
            if(write(fd2, ", ", 2) != 2) close_with_error(fd1, fd2);
        }

        if (count == 524288) close_with_error(fd1, fd2);

        char arr[16];
        int size = snprintf(arr, sizeof(arr), "%d", number);
        if(write(fd2, arr, size) != size) close_with_error(fd1, fd2);
        count++;
    }

    char end_array[] = "};\n";
    if (write(fd2, &end_array, 3) != 3) close_with_error(fd1, fd2);

    char arr[24];
    int size = snprintf(arr, sizeof(arr), "uint32_t arrN = %d;\n", count);
    if(write(fd2, arr, size) != size) close_with_error(fd1, fd2);

    exit(0);
}