// Koпирайте файл /etc/passwd в текущата ви работна директория и променете разделителят на копирания файл от ":", на "?"

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <err.h>

int main(void) {
	int fd1;
	if ((fd1 = open("/etc/passwd", O_RDONLY)) == -1) {
		err(1, "/etc/passwd");
	}
		
	int fd2;
	if ((fd2 = open("passwd", O_CREAT|O_TRUNC|O_RDWR, S_IRWXU)) == -1) {
		err(1, "passwd");
	}	

	ssize_t read_status;
	ssize_t write_status;
	char buff;
	
	while((read_status = read(fd1, &buff, 1)) && read_status != -1) {
		if (buff == ':') buff = '?';
		write_status = write(fd2, &buff, 1);
		if (write_status == -1) break;
	}

	close(fd1);
	close(fd2);

	if (read_status == -1 || write_status == -1) {
		err(1, "err");
	}

	exit(0);
}
