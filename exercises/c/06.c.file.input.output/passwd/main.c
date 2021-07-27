// Koпирайте файл /etc/passwd в текущата ви работна директория и променете разделителят на копирания файл от ":", на "?"

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <err.h>

int main() {
    int fd1 = open("/etc/passwd", O_RDONLY);
    if (fd1 == -1) err(1, "%s", "/etc/passwd");

    int fd2 = open("passwd", O_CREAT|O_WRONLY|O_TRUNC, S_IRWXU);
    if (fd2 == -1) {
        close(fd1);
        err(1, "%s", "passwd");
    }

    char buff;
    char q = '?';

    while (read(fd1, &buff, 1)) {
        if (buff == ':') {
            if (write(fd2, &q, 1) == -1) {
                close(fd1);
                close(fd2);
                err(1, "error while writing");
            }

            continue;
        }

        if (write(fd2, &buff, 1) == -1) {
            close(fd1);
            close(fd2);
            err(1, "error while writing");
        }
    }

    close(fd1);
    close(fd2);
    exit(0);
}
