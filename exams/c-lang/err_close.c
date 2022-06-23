#include <stdio.h>
#include <err.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <stdarg.h>

void err_close(int eval, const char* msg, int cnt, const int* fds, ...) {
	int errcode = errno;
	va_list args;
	va_start(args, fds);

	while(cnt > 0) {
		int fd = va_arg(args, int);
		close(fd);
		cnt--;
	}

	va_end(args);
	errno = errcode;
	err(eval, "%s", msg);
}

int main() {

	int fd1 = open("t1", O_CREAT | O_TRUNC | O_WRONLY, S_IRUSR | S_IWUSR);
	int fd2 = open("t2", O_CREAT | O_TRUNC | O_WRONLY, S_IRUSR | S_IWUSR);
		
	err_close(1, "err 1 2", 2, &fd1, &fd2);
}
