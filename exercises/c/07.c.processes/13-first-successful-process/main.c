// Да се напише програма на C, която получава като командни параметри две команди (без параметри). 
// Изпълнява ги едновременно и извежда на стандартния изход номера на процеса на първата завършила 
// успешно. Ако нито една не завърши успешно извежда -1.

#include <sys/types.h>
#include <sys/wait.h>
#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

void execute(char* command) {
    if (execl(command, command, (char*)NULL) == -1) {
        err(1, "exec for %s failed", command);
    }
    
    exit(0);
}

int main(int argc, char* argv[]) {
    if (argc - 1 != 2) errx(1, "2 args needed");

    int pid1 = fork();
    if (pid1 == 0) execute(argv[1]);
    
    int pid2 = fork();
    if (pid2 == 0) execute(argv[2]);

    int status;
    int child_pid;
    while((child_pid = wait(&status)) && child_pid != -1) {
        if (WIFEXITED(status) && WEXITSTATUS(status) == 0) {
            printf("%d", child_pid);
            exit(0);
        }
    }

    exit(-1);
}

