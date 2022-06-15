// Реализирайте команда swap, разменяща съдържанието на два файла, подадени като входни параметри.

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <err.h>

int main(int argc, char* argv[]) {
    if (argc - 1 != 2) {
        errx(1, "2 args needed");
    }

    int fd1;
    int fd2;
    int fd3;
    
    if ((fd1 = open(argv[1], O_RDWR, S_IRWXU)) == -1) {
        err(1, "%s", argv[1]);
    }

    if ((fd2 = open(argv[2], O_RDWR, S_IRWXU)) == -1) {
        close(fd1); 
        err(1, "%s", argv[2]);
    }

    if ((fd3 = open("temp", O_CREAT|O_RDWR|O_TRUNC, S_IRWXU)) == -1) {
        close(fd1);
        close(fd2);
        err(1, "%s", "temp");
    }

    int read_status;
    char buff[4096];
    int write_status;

    while((read_status = read(fd1, &buff, 4096)) && read_status != -1) {        
        write_status = write(fd3, &buff, read_status);
        if (write_status == -1) break;
    }
    
    lseek(fd1, 0, SEEK_SET);

    if (read_status != -1 && write_status != -1) {
        while((read_status = read(fd2, &buff, 4096)) && read_status != -1) {
            write(fd1, &buff, read_status);
            if (write_status == -1) break;       
        }
    }

    lseek(fd2, 0, SEEK_SET);
    lseek(fd3, 0, SEEK_SET);

    if (read_status != -1 && write_status != -1) {
        while((read_status = read(fd3, &buff, 4096)) && read_status != -1) {
            write(fd2, &buff, read_status);
            if (write_status == -1) break;
        }
    }

    close(fd1);
    close(fd2);
    close(fd3);
    exit(0);
}
