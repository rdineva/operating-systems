// Реализирайте команда head без опции (т.е. винаги да извежда на 
// стандартния изход само първите 10 реда от съдържанието 
// на файл подаден като първи параматър)

#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <err.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    if (argc-1 != 1) {
    	errx(1, "1 arg needed");
    }	    

	int fd1 = open(argv[1], O_RDONLY);
    if (fd1 == -1) {
        err(1, "%s", argv[1]);
    }

    int fd2;
    char c;
    int lines = 0;
    
    while((fd2 = read(fd1, &c, 1)) && lines < 10) {
        if (fd2 == -1) {
			close(fd1);
    		close(fd2);
            err(1, "%s", argv[1]);
        }

	    if (c == '\n') {
		    lines++;
	    }

        write(0, &c, 1);
    }

    close(fd1);
    close(fd2);
    exit(0);
}

