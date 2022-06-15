// Да се напише програма на С, която получава като параметри три команди (без параметри), 
// изпълнява ги последователно, като изчаква края на всяка и извежда на стандартния изход 
// номера на завършилия процес, както и неговия код на завършване.

#include <err.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    if (argc - 1 != 3) {
        errx(1, "3 args needed");
    }

    for (int i = 1; i < argc; i++) {
        int pid = fork();
        int status;

        if (pid == 0) {
            if (execl(argv[i], argv[i], (char*)NULL) == -1) {
                err(1, "%s", argv[i]);
            }
        }

        int child_pid = wait(&status);        
        printf("%s executed successfully with exit status %d and pid %d\n", argv[i], status, child_pid);
    }
    
    exit(0);
}
