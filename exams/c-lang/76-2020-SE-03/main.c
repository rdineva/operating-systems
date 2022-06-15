#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <stdlib.h>
#include <stdint.h>

#define N 8

struct file {
	char name[N];
	uint32_t offset;
	uint32_t length;
};

int main(int argc, char* argv[]) {
	int fd = open(argv[1], O_RDONLY);
	if (fd == -1) err(1, "%s", argv[1]);

	struct file f[N];
	int cnt = 0;

	uint16_t final_result;

	while(read(fd, &f[cnt], sizeof(struct file))) {
		// check read status
		printf("%s\n", f[cnt].name);
		int f_read = open(f[cnt].name, O_RDONLY);
		if (f_read == -1) err(1, "%s", f[cnt].name);
			
		lseek(f_read, f[cnt].offset * sizeof(uint16_t)*cnt, SEEK_SET);
	
		int pf[2];
		int pid = fork();
		uint16_t elements;
		uint16_t result;
		
		if (pid == 0) {
			close(pf[0]);
			dup2(pf[1], 0);

			for (int i = 0; i < f[cnt].length; i++) {
				if (read(fd, &elements, sizeof(uint16_t))) {
					err(1, "err");
				}
			
				if (i == 0) {
					result = elements;
					continue;
				}

				result ^= elements;
			}
			
			if (execl("/bin/echo", "/bin/echo", result, (char*)NULL)) {
				err(1, "err exec");
			}

			cnt++;
		}

		close(pf[1]);
		final_result ^= pf[0];
		close(pf[0]);
	}

	close(fd);
	printf("result: %d", final_result);
	exit(0);
}
