#include <stdio.h>
#include <err.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char* argv[]) {
	if (argc <= 1) errx(1, "ERROR: not enough args!");	

	int fd;
	int i = 1;
  
	while((fd = open(argv[i], O_RDONLY)) != -1 && i <= argc) {
		int read_size;
		int write_size;
		char c[4096];

		while((read_size = read(fd, &c, sizeof(c))) && read_size != -1) {
			write_size = write(1, &c, read_size);
			if (write_size == -1) break;
		}

		if (read_size == -1 || write_size == -1) {
			close(fd);
			err(1, "err");
		}

		i++;
	}
	
	close(fd);
	exit(0);
}
