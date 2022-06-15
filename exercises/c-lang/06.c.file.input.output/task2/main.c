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
	if (argc != 2) errx(1, "err");
	
	int fd;
	if ((fd = open(argv[1], O_RDONLY)) == -1) {
		errx(1, "1 argg");
	}

	char c;
	int lines=0;

	while(read(fd, &c, 1) && lines < 10) {
		write(0, &c, 1);
		if (c == '\n') {
			lines++;
		}
	}

	close(fd);
	exit(0);
}

