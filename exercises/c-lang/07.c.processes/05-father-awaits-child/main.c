// Да се напише програма на C, която е аналогична на горния пример, но принуждава бащата да изчака сина си да завърши.

#include <unistd.h>
#include <err.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>

int main() {
    int pid = fork();
    int status;

    if (pid > 0) {
        wait(&status);
        printf("This is father.\n");
    } else {
        printf("This is child.\n");
    }

    exit(0);
}
