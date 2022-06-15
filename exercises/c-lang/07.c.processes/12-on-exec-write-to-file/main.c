// Да се напише програма на C, която получава като параметри от команден ред 
// две команди (без параметри) и име на файл в текущата директория. 
// Ако файлът не съществува, го създава. Програмата изпълнява командите 
// последователно, по реда на подаването им. Ако първата команда завърши успешно, 
// програмата добавя нейното име към съдържанието на файла, подаден като команден параметър. 
// Ако командата завърши неуспешно, програмата уведомява потребителя чрез подходящо съобщение.

#include <sys/types.h>
#include <sys/wait.h>
#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char* argv[]) {
    if (argc - 1 != 3) errx(1, "3 args needed");

    int fd = open(argv[3], O_CREAT | O_TRUNC | O_WRONLY, S_IRWXU);
    if (fd == -1) err(1, "%s", argv[3]);

    int pid = fork();

    if (pid == 0) {
        if (execlp(argv[1], argv[1], (char*)NULL) == -1) {
            err(1, "exec failed for %s", argv[1]);
        }

        exit(0);
    }

    int status;
    wait(&status);

    if (WIFEXITED(status)) {
        if (WEXITSTATUS(status) == 0) {
            if (write(fd, argv[1], sizeof(argv[1])+1) == -1) {
                close(fd);
                err(1, "couldnt write to %s", argv[3]);
            }
        } else {
            printf("%s failed and was not added to file %s\n", argv[1], argv[3]);
            exit(-1);
        }
    }
    
    if (execlp(argv[2], argv[2], (char*)NULL) == -1) {
        err(1, "exec failed for %s", argv[2]);
    }

    exit(0);
}

