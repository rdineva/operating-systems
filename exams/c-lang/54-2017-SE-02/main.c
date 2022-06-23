#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <stdio.h>
#include <stdbool.h>

int line_index = 1;

void add_line_index() {
	char indexAsChar[20];
	int size = sprintf(indexAsChar, "%d", line_index);

    if (write(1, indexAsChar, size) != size) {
        err(1, "error writing index");
    }
}

void write_to_stdout(int fd, bool enumerate) {
	char symbol;
	bool is_new_line = true;

	while(read(fd, &symbol, sizeof(char))) {
		if (enumerate && is_new_line) {
    	    add_line_index(line_index);
			is_new_line = false;
	    }

		if (write(1, &symbol, sizeof(symbol)) != sizeof(symbol)) {
			 if (fd != 0) close(fd);
             err(2, "error writing read symbol");			
		}

		if (symbol == '\n') {
            line_index++;
			is_new_line = true;
		}
	}
}

int main(int argc, char* argv[]) {
	bool enumerate = false;
	int start_index = 1;
	
	if (argc == 1) {
        write_to_stdout(0, enumerate);
        exit(0);
    }

	if (strcmp(argv[1], "-n") == 0) {
        enumerate = true;
        start_index = 2;
    	if (argc == 2) {
			write_to_stdout(0, enumerate);	
		}
	}

	for(int i = start_index; i < argc; i++) {
		if (strcmp(argv[i], "-") == 0) {
			write_to_stdout(0, enumerate);
		} else {
			int fd = open(argv[i], O_RDONLY);
	        if (fd == -1) err(1, "err opening %s", argv[i]);
			write_to_stdout(fd, enumerate);
		}
	}

	exit(0);
}
