// Да се напише програма на C, която получава като параметри от команден ред 
// две команди (без параметри). Изпълнява първата. Ако тя е завършила 
// успешно изпълнява втората. Ако не, завършва с код 42.
    
#include <err.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    if (argc - 1 != 2) errx(1, "2 args needed");

    int pid = fork();

    if (pid == 0) {
        if (execl(argv[1], argv[1], (char*)NULL) == -1) {
            err(1, "couldnt exec %s", argv[1]);        
        }

        exit(0);
    } 

    int status;
    wait(&status);

    if (WIFEXITED(status) && WEXITSTATUS(status) == 0) {
        if (execl(argv[2], argv[2], (char*)NULL) == -1) {
            err(1, "couldn't exec %s", argv[2]);
        }
    } 
    
    exit(42);        
}
