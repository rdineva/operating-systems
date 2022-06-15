#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <err.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char* argv[]) {
	if (argc != 4) errx(1, "4 params needed");
		
	int fd;
	if ((fd = open(argv[argc-1], O_WRONLY|O_CREAT|O_TRUNC, S_IRWXU)) == -1) {
		err(1, "err %s", argv[argc-1]);
	}

	for (int i = 1; i < argc - 1; i++) {
		pid_t pid = fork();	
		if (pid == 0) {
			if (execlp(argv[i], argv[i], (char*)NULL) == -1) {
				close(fd);
				err(1, "execlp %s", argv[i]);
			}
		}

		int status;
		wait(&status);
		if (WIFEXITED(status)) {
			if (WEXITSTATUS(status) == 0) {
				char buffer[50];
				int size = snprintf(buffer, sizeof(argv[i])+1, "%s\n", argv[i]);
		
				if (write(fd, &buffer, size) != size) {
					close(fd);
					err(1, "err writing %s", argv[i]);
				}
			} else {
				printf("Error while executing %s\n", argv[i]);
				close(fd);
				exit(1);
			}
		}
	}

	close(fd);
	exit(0);
}
