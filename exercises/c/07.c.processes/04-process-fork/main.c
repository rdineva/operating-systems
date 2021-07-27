// Да се напише програма на C, която създава процес дете и демонстрира принцина на конкурентност при процесите.

#include <unistd.h>
#include <err.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
    int pid = fork();

    if (pid > 0) {
        printf("This is father.\n");
    } else {
        printf("This is child.\n");
    }

    exit(0);
}
