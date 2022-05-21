// Напишете програма, която приема точно 2 аргумента. Първият може да бъде само --min, --max или --print (вижте man 3 strcmp).
// Вторият аргумент е двоичен файл, в който има записани цели неотрицателни двубайтови числа (uint16_t - вижте man stdint.h). 
// Ако първият аргумент е:
//    --min - програмата отпечатва кое е най-малкото число в двоичния файл.
//    --max - програмата отпечатва кое е най-голямото число в двоичния файл.
//    --print - програмата отпечатва на нов ред всяко число.
#include <string.h>
#include <err.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdint.h>

int main(int argc, char* argv[]) {
	if (argc != 3) errx(1, "ERROR: 3 args needed");
	
	if ((strcmp(argv[1], "--min") != 0) && 
		(strcmp(argv[1], "--max") != 0) && 
		(strcmp(argv[1], "--print") != 0)
	) {
		errx(1, "ERROR: invalid first arg");
	}

	int fd;
	if ((fd = open(argv[2], O_RDONLY)) == -1) {
		err(1, "%s", argv[2]);
	}

	uint16_t min = 65535;
	uint16_t max = 0;
	uint16_t buff;
	int read_status;

	while((read_status = read(fd, &buff, sizeof(buff))) && read_status != -1) {
		if (buff < min) min = buff;
		if (buff > max) max = buff;
		if (strcmp(argv[1], "--print") == 0) printf("%d\n", buff);
	}
	
	if (read_status == -1) {
		close(fd);
		err(1, "err");
	}

	if (strcmp(argv[1], "--min") == 0) printf("min=%d\n", min);
   	if (strcmp(argv[1], "--max") == 0) printf("max=%d\n", max);

	close(fd);
	exit(0);
}
