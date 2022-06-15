// Да се напише програма на C, която която създава файл в текущата директория 
// и генерира два процесa, които записват низовете foo и bar в създадения файл.
// Програмата не гарантира последователното записване на низове.
// Променете програмата така, че да записва низовете последователно, като първия е foo.

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <unistd.h>
#include <err.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
    int fd = open("temp", O_CREAT | O_TRUNC | O_WRONLY, S_IRWXU);
    if (fd == -1) err(1, "couldn't create file temp");

    int pid = fork();
    if (pid == 0) {
        if (write(fd, "foo", 3) != 3) {
            err(1, "couldn't write foo");
        }

        exit(0);
    }

    // wait and status added for determinism
    int status;
    wait(&status);

    if (write(fd, "bar", 3) != 3) {
        err(1, "couldn't write bar");
    }

    exit(0);
}
