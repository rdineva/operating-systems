// Реализирайте команда cp, работеща с произволен брой подадени входни параметри.
// usage: ./main.c <file 1> <file 2> ... <file n> <dir>

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <err.h>


int main(int argc, char* argv[]) {
    if (argc - 1 < 2) {
        errx(1, "more args needed");
    }
    
    for(int i = 1; i < argc - 1; i++) {
        int fd1;            
        if ((fd1 = open(argv[i], O_RDONLY)) == -1) {
            err(1, "%s", argv[i]);
        }
        
        char file_path[FILENAME_MAX];
        snprintf(file_path, sizeof file_path, "%s/%s", argv[argc-1], argv[i]);

        int fd2;
        if ((fd2 = open(file_path, O_CREAT|O_WRONLY|O_TRUNC, S_IRWXU)) == -1) {     
            close(fd1);
			err(1, "%s", file_path);
        }

        char buff[4098];
        ssize_t read_status;		
        ssize_t write_status;

        while((read_status = read(fd1, &buff, sizeof(buff))) && read_status != -1) {            
            write_status = write(fd2, &buff, read_status);
			if (write_status == -1) break;
        }

        close(fd1);
        close(fd2);
        if (read_status == -1 || write_status == -1) err(1, "%s", argv[i]);
    }

    exit(0);
}
