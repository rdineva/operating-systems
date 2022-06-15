#include <sys/types.h>
#include <sys/wait.h>
#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char* argv[]) {
	if (argc != 2) errx(1, "1 arg needed");

	int fd;
	if ((fd = open(argv[1], O_WRONLY|O_CREAT|O_TRUNC, S_IRWXU)) == -1) {
		err(1, "%s", argv[1]);
	}

	if (write(fd, "foo", 3) != 3) {
		close(fd);
		err(1, "err writing foo...");
	}

	pid_t pid = fork();
	if (pid == 0) {
		if (write(fd, "bar\n", 4) != 4) {
			close(fd);
			err(1, "err writing bar...");
		}

		exit(0);
	}

	int status;
	wait(&status);

	if (WIFEXITED(status) && WEXITSTATUS(status) == 0) {
		if (write(fd, "o\n", 2) != 2) {
			close(fd);
			err(1, "err writing o...");
		}

		exit(0);
	}

	exit(1);
}
