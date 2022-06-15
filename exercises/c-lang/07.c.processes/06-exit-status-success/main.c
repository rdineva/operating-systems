// Да се напише програма на С, която получава като параметър команда (без параметри) 
// и при успешното ѝ изпълнение, извежда на стандартния изход името на командата.

#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <err.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    if (argc - 1 != 1) {
        errx(1, "1 arg needed");
    }

    int pid = fork();
    int status;

    if (pid > 0) {
        wait(&status);
        
        if (WIFEXITED(status) && WEXITSTATUS(status) == 0) {
            printf("%s\n", argv[1]);
        }
    } else {
        if (execl(argv[1], argv[1], (char*)NULL) == -1) {
            err(1, "couldn't exec %s", argv[1]);
        }
    }

    exit(0); 
}
