#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <err.h>
#include <fcntl.h>
#include <errno.h>
#include <stdint.h>

int comparator(const void* a, const void* b) {
	return (*(uint32_t*)a - *(uint32_t*)b);
}

int main(int argc, char* argv[]) {
	if (argc != 2) errx(1, "Err: 2 params needed!");

	int fd1 = open(argv[1], O_RDONLY);
	if (fd1 == -1) err(2, "Err: opening %s failed", argv[1]);

	struct stat st;
	if (fstat(fd1, &st) == -1) {
		int errcode = errno;
		close(fd1);
		errno = errcode;
		err(3, "Err: fstat failed");
	}

	off_t size = st.st_size;
	
	const int allowedSize = 256 * 1024 * 1024;
	int loops = size / allowedSize;
	int remainder = size % allowedSize;
	
	int fd_temp1;

	if (loops > 0) {
		fd_temp1 = open("temp1", O_CREAT | O_TRUNC | O_WRONLY, S_IRUSR | S_IWUSR);
		if (fd_temp1 == -1) {
			int errcode = errno;
	        close(fd1);
    	    errno = errcode;
        	err(3, "Err: open failed");
		}

		uint32_t* arr = malloc(allowedSize);
		
		if (read(fd1, arr, allowedSize) == -1) {
			int errcode = errno;
            close(fd1);
			close(fd_temp1);
            errno = errcode;
            err(3, "Err: read failed");
		}
	
		qsort(arr, allowedSize/sizeof(uint32_t), sizeof(uint32_t), comparator);
		
		if (write(fd_temp1, arr, allowedSize) == -1) {
			int errcode = errno;
            close(fd1);
			close(fd_temp1);
            errno = errcode;
            err(3, "Err: write failed");
		}	
		
		free(arr);
	}	

	int fd_temp2;
	if (remainder > 0) {
		fd_temp2 = open("temp2", O_CREAT | O_TRUNC | O_WRONLY, S_IRUSR | S_IWUSR);
		if (fd_temp2 == -1) {
 			int errcode = errno;
            close(fd1);
            errno = errcode;
            err(3, "Err: open failed");
		}
	
		uint32_t* arr = malloc(remainder);
	
		if (read(fd1, arr, remainder) == -1) {
            int errcode = errno;
            close(fd1);
			close(fd_temp2);
            errno = errcode;
            err(3, "Err: read failed");
        }

        qsort(arr, remainder/sizeof(uint32_t), sizeof(uint32_t), comparator);

        if (write(fd_temp2, arr, remainder) == -1) {
            int errcode = errno;
            close(fd1);
            close(fd_temp2);
            errno = errcode;
            err(3, "Err: write failed");
        }

        free(arr);
	}

	int fd_final = open("final", O_CREAT | O_TRUNC | O_WRONLY, S_IRUSR | S_IWUSR);
	if (fd_final == -1) {
    	int errcode = errno;
        close(fd1);
        close(fd_temp1);
        errno = errcode;
        err(3, "Err: open final failed");
    }

	if (lseek(fd_temp1, 0, SEEK_SET)) {
		int errcode = errno;
        close(fd1);
        close(fd_temp1);
        errno = errcode;
        err(3, "Err: lseek failed");
	}

	if (lseek(fd_temp2, 0, SEEK_SET)) {
        int errcode = errno;
        close(fd1);
        close(fd_temp1);
        errno = errcode;
        err(3, "Err: lseek failed");
    }

 
	if (loops > 0 && remainder > 0) {
		uint32_t a;
		uint32_t b;
  		while(read(fd_temp1, &a, sizeof(uint32_t)) && read(fd_temp2, &b, sizeof(uint32_t))) {
			// TODO: check read size	
			
			if (a > b) {
				write(fd_final, &a, sizeof(uint32_t));
				lseek(fd_temp2, -sizeof(uint32_t), SEEK_CUR);
			} else {
			 	write(fd_final, &b, sizeof(uint32_t));
				lseek(fd_temp1, -sizeof(uint32_t), SEEK_CUR);
			}
		}
		
		while(read(fd_temp1, &a, sizeof(uint32_t))) {
			write(fd_final, &a, sizeof(uint32_t));
		}

		while(read(fd_temp2, &b, sizeof(uint32_t))) {
			write(fd_final, &b, sizeof(uint32_t));
		}
	}

	close(fd_temp1);
	close(fd_final);
	close(fd1);
	exit(0);
}

