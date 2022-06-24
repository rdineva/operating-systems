#include <stdlib.h>
#include <err.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>

int main() {
	uint8_t arr1[] = { 0xf5, 0xc4, 0xb1, 0x59 };
	uint8_t arr2[] = { 0xf5, 0xc4, 0x59, 0x59 };
		
	int fd1 = open("../f1.bin", O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR);
	if (fd1 == -1) err(1, "err opening fd1");
	
	if (write(fd1, &arr1, sizeof(arr1)) != sizeof(arr1)) {
		close(fd1);
		err(2, "err writing to fd1");
	}

	int fd2 = open("../f2.bin", O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR);
	if (fd2 == -1) {
		close(fd1);
		err(1, "err opening fd2");
	}

	if (write(fd2, &arr2, sizeof(arr2)) != sizeof(arr2)) {
		close(fd1);
		close(fd2);
		err(2, "err writing to fd2");
	}

	close(fd1);
	close(fd2);	
	exit(0);
}
