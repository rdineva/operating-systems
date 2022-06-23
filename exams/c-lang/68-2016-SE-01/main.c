#include <stddef.h>
#include <stdlib.h>
#include <unistd.h>
#include <err.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char* argv[]) {
	if (argc != 2) errx(1, "Err: 2 args needed!");

	int pf[2];
	if (pipe(pf) == -1) err(3, "err pipe");
	pid_t pid = fork();

	if (pid == 0) {
		close(pf[0]);
		dup2(pf[1], 1); // closes STDIN and forwards it to pf[1]

		if (execl("/bin/cat", "/bin/cat", argv[1], (char*)NULL) == -1) {
			close(pf[1]);
			err(4, "err exec cat");
		}
	}

	close(pf[1]);
	dup2(pf[0], 0);
	
	if (execl("/bin/sort", "/bin/sort", (char*)NULL) == -1) {
		close(pf[0]);
		err(5, "err sort");
	}

	close(pf[0]);
	exit(0);
}

