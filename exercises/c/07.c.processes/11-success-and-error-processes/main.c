// Да се напише програма на C, която изпълнява последователно подадените ѝ 
// като параметри команди, като реализира следната функционалност постъпково:
// - main cmd1 ... cmdN Изпълнява всяка от командите в отделен дъщерен процес.
// - ... при което се запазва броя на изпълнените команди, които са дали грешка и броя на завършилите успешно.

#include <sys/types.h>
#include <sys/wait.h>
#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char* argv[]) {
    if (argc < 1) errx(1, "not enough args");

    int success = 0;
    int failure = 0;

    for (int i = 1; i < argc; i++) {
        int pid = fork();
    
        if (pid == 0) {
            if (execl(argv[i], argv[i], (char*)NULL) == -1) {
                err(1, "exec failed for %s", argv[i]);
            }

            exit(0);
        }

        int status;
        wait(&status);
        
        if (WIFEXITED(status)) {
            if (WEXITSTATUS(status) == 0) success++;
            else failure++;
        }
    }

    printf("Successes: %d\n Failures: %d\n", success, failure);
    exit(0);
}
