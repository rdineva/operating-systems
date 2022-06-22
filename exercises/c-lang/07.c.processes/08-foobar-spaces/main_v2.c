#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <err.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char* argv[]) {
	if (argc != 2) errx(1, "ERROR: 1 param needed");

    	int fd;
	if ((fd = open(argv[1], O_RDWR|O_CREAT|O_TRUNC, S_IRWXU)) == -1) {
		err(1, "%s", argv[1]);
	}
	
    pid_t pid = fork();
	int status;
	if (pid == 0) {
		if(write(fd,"foobar", 6) != 6) {
			err(1, "err writing foobar");
		}

		exit(0);
	} else {
		wait(&status);
		lseek(fd, 0, SEEK_SET);
		char buff;
		int cnt = 1;
		while (read(fd, &buff, 1) == 1) {
			printf("%s", &buff);
			if (cnt % 2 == 0) printf(" ");
			cnt++;
		}
	}	

	exit(0);
}
