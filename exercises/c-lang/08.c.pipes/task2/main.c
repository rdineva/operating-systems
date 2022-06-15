#include <sys/types.h>
#include <sys/wait.h>
#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

int main(int argc, char* argv[]) {
	if (argc != 2) errx(1, "1 arg needed");

	int pf[2];
	if (pipe(pf) == -1) err(1, "err pipe");

	pid_t pid = fork();	
	if (pid == -1) err(1, "err fork");

	if (pid == 0) {
		close(pf[1]);	
		char buff;

		while(read(pf[0], &buff, 1) > 0) {
			write(1, &buff, 1);
		}

		close(pf[0]);
		exit(0);
	}

	close(pf[0]);
	write(pf[1], argv[1], strlen(argv[1]));
	close(pf[1]);
	wait(NULL);

	exit(0);
}
