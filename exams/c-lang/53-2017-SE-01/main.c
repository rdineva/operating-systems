#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdint.h>
#include <err.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdbool.h>
#include <errno.h>

struct data {
	uint16_t offset;
	uint8_t original;
	uint8_t new;
}__attribute__((packed));

void err_close(int eval, const char* msg, int fd1, int fd2, int fd3) {
	int errcode = errno;
	close(fd1);
	close(fd2);
	close(fd3);
	errno = errcode;
	err(eval, "Err: %s", msg);
}

int main(int argc, char* argv[]) {
	if (argc != 4) errx(1, "Err: you need 3 params!");

	int fd1 = open(argv[1], O_RDONLY);
	if (fd1 == -1) err(2, "err: opening %s", argv[1]);
	
	struct stat st1;
	if (fstat(fd1, &st1) == -1) {
		close(fd1);
		err(3, "err fstat fd1");
	}

	if (st1.st_size % sizeof(uint8_t) != 0) {
		close(fd1);
		err(4, "err file 1 format is wrong");
	}
	
	int fd2 = open(argv[2], O_RDONLY);
	if (fd2 == -1) err(2, "err: opening %s", argv[2]);
	
	struct stat st2;
	if (fstat(fd2, &st2) == -1) {
		close(fd1);
		close(fd2);		
		err(3, "err fstat fd2");
	}

	if (st2.st_size % sizeof(uint8_t) != 0) {
		close(fd1);
		close(fd2);	
		err(4, "err file 2 format is wrong");
	}

	if (st1.st_size != st2.st_size) {
		close(fd1);
		close(fd2);
		errx(5, "Err: file sizes are different");
	}

	int fd3 = open(argv[3], O_CREAT | O_TRUNC | O_WRONLY, S_IRUSR | S_IWUSR);
	if (fd3 == -1) {
		close(fd1);
		close(fd2);
		err(6, "Err: opening %s", argv[3]);
	}

	uint8_t buff1, buff2;
	int read_status1, read_status2;
	uint16_t pos = 0;

	while((read_status1 = read(fd1, &buff1, sizeof(uint8_t)) > 0) &&
		(read_status2 = read(fd2, &buff2, sizeof(uint8_t)) > 0)
	) {
		if (buff1 != buff2) {
			struct data d;
			d.offset = pos;
			d.original = buff1;
			d.new = buff2;
			
			if (write(fd3, &d, sizeof(struct data)) != sizeof(struct data)) {
				err_close(7, "writing to patch file", fd1, fd2, fd3);
			}
		}

		++pos;
	}

	if (read_status1 == -1 || read_status2 == -1) {
		err_close(8, "reading fd1", fd1, fd2, fd3);
	}

	close(fd1);
	close(fd2);
	close(fd3);
	exit(0);
}
