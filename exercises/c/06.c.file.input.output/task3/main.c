// Реализирайте команда wc, с един аргумент подаден като входен параметър
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char* argv[]) {
    if (argc - 1 != 1) {
        errx(1, "1 arg needed");
    }

    int fd1 = open(argv[1], O_RDONLY);
    if (fd1 == -1) {
        err(1, "%s", argv[1]);
    }

    int fd2;
    char c;
    int lines = 0;
    int words = 0;
    int chars = 0;

    while((fd2 = read(fd1, &c, 1))) {
        if (fd2 == -1) {
            err(1, "%s", argv[1]);
        }

        if (c == '\n') {
            lines++;
            words++;
        }        

        if (c == ' ') {
            words++;
        }

        chars++;
    }

    printf("Lines: %d\n", lines);
    printf("Words: %d\n", words);
    printf("Chars: %d\n", chars);

    close(fd1);
    close(fd2);
    exit(0);  
}
