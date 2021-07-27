// Да се напише програма на C, която изпълнява команда ls с точно един аргумент.

#include <unistd.h>
#include <err.h>

int main(int argc, char* argv[]) {
    if (argc - 1 != 1) {
        errx(1, "1 arg needed");
    }
    
    if(execl("/bin/ls", "ls", argv[1], (char*)NULL) == -1) {
        errx(1, "couldn't exec ls");
    }    
}
