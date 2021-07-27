// Копирайте съдържанието на файл1 във файл2

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char* argv[]) {
    int fd1;
    int fd2;
    char* buff;

    if(argc-1 != 2) {
        printf("ERROR: 2 args needed\n");
        exit(1);
    }
    
    if((fd1 = open(argv[1], O_RDONLY)) == -1) {
        write(2, "ERROR: could not open first file\n", 40);
        exit(2);
    }

    if((fd2 = open(argv[2], O_CREAT|O_WRONLY|O_TRUNC, S_IRWXU)) == -1) {
        write(2, "ERROR: could not open second file\n", 40);
        close(fd1);
        exit(3);
    }

    int read_status;
    int write_status;

    while((read_status = read(fd1, &buff, 1)) && read_status != -1) {
        write_status = write(fd2, &buff, 1);

        if (write_status == -1) break;
    }

    close(fd1);
    close(fd2);

    if (read_status == -1 || write_status == -1) {
        exit(4);        
    }

    exit(0);
}
