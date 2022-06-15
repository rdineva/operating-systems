// Да се напише програма на С, която получава като параметър име на файл. 
// Създава процес син, който записва стринга foobar във файла 
// (ако не съществува, го създава, в противен случай го занулява), след което 
// процеса родител прочита записаното във файла съдържание и го извежда 
// на стандартния изход, добавяйки по един интервал между всеки два символа.

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <unistd.h>
#include <err.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    if (argc - 1 != 1) {
        errx(1, "1 arg needed");
    }

    int fd = open(argv[1], O_CREAT | O_RDWR | O_TRUNC, S_IRWXU);
    if (fd == -1) {
        err(1, "%s", argv[1]);
    }    

    int pid = fork();

    if (pid == 0) {
        if (write(fd, "foobar", 6) != 6) {
            err(1, "error while writing to file");
        }

        exit(0);
    }
    
    int status;
    wait(&status);
    lseek(fd, 0, SEEK_SET);
   
    char* result = malloc(9);
    if (result == (char*)NULL) {
        close(fd);
        err(1, "malloc failed");
    }

    int cnt = 1;
    int read_size;
    char c;
    int i = 0;
 
    while((read_size = read(fd, &c, 1)) != 0) {
        if (read_size == -1) err(1, "error reading from file");
        result[i++] = c;
        if (cnt == 2) {
            result[i++] = ' ';
            cnt = 0;
        }

        cnt++;
    }
       
    result[--i] = '\0';
    printf("%s", result);
    close(fd);
    free(result);
    exit(0);
}
