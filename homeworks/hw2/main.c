#include <stdio.h>
#include <err.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdint.h>
#include <time.h>

char WRITE[] = "write";
char READ[] = "read";
char RECORD[] = "record";
char REPLAY[] = "replay";

// common function to check if result from read/write calls is as expected (if there was an error)
void status_check(int size, int expected_size, int fd1, int fd2, const char mode[])
{
    if (size != expected_size)
    {
        close(fd1);
        close(fd2);
        err(1, "ERROR: %s failed", mode);
    }
}

// reads slot data
void handle_slot(int read_fd, int write_fd, const char mode[], double ms, uint16_t code)
{
    ssize_t read_size;
    uint8_t slot;
    read_size = read(read_fd, &slot, sizeof(uint8_t));
    status_check(read_size, sizeof(uint8_t), read_fd, write_fd, READ);

    unsigned char text[13];
    read_size = read(read_fd, &text, sizeof(&text));
    status_check(read_size, sizeof(&text), read_fd, write_fd, READ);

    fprintf(stderr, "<slot text> %d: %s\n", slot, text);

    ssize_t write_size;

    if (strcmp(mode, RECORD) == 0)
    {
        write_size = write(write_fd, &ms, sizeof(double));
        status_check(write_size, sizeof(double), read_fd, write_fd, WRITE);
    }

    write_size = write(write_fd, &code, sizeof(uint16_t));
    status_check(write_size, sizeof(uint16_t), read_fd, write_fd, WRITE);

    write_size = write(write_fd, &slot, sizeof(uint8_t));
    status_check(write_size, sizeof(uint8_t), read_fd, write_fd, WRITE);

    write_size = write(write_fd, &text, sizeof(&text));
    status_check(write_size, sizeof(&text), read_fd, write_fd, WRITE);
}

// reads state data
void handle_state(int read_fd, int write_fd, const char mode[], double ms, uint16_t code)
{
    ssize_t read_size;
    uint16_t slots;
    read_size = read(read_fd, &slots, sizeof(uint16_t));
    status_check(read_size, sizeof(uint16_t), read_fd, write_fd, READ);

    int a[16];
    int n = slots;
    for (int i = 0; i < 16; i++)
    {
        a[i] = n % 2;
        n = n / 2;
    }

    uint32_t temp_buf;
    read_size = read(read_fd, &temp_buf, sizeof(uint32_t));
    status_check(read_size, sizeof(uint32_t), read_fd, write_fd, READ);

    double kelvins = (double)temp_buf / (double)100;
    double temp = (double)kelvins - 273.15;
    fprintf(stderr, "<state> temp: %.2f°C, ", temp);

    for (int i = 0; i < 16; i++)
    {
        char c = ' ';
        if (a[i] == 1)
            c = 'X';
        fprintf(stderr, "%d[%c] ", i, c);
    }

    fprintf(stderr, "\n");

    ssize_t write_size;
    if (strcmp(mode, RECORD) == 0)
    {
        write_size = write(write_fd, &ms, sizeof(double));
        status_check(write_size, sizeof(double), read_fd, write_fd, WRITE);
    }

    write_size = write(write_fd, &code, sizeof(uint16_t));
    status_check(write_size, sizeof(u_int16_t), read_fd, write_fd, WRITE);

    write_size = write(write_fd, &slots, sizeof(uint16_t));
    status_check(write_size, sizeof(uint16_t), read_fd, write_fd, WRITE);

    write_size = write(write_fd, &temp_buf, sizeof(uint32_t));
    status_check(write_size, sizeof(uint32_t), read_fd, write_fd, WRITE);
}

// depending on the code given as a parameter, calls function that reads state or slot text data
void handle_binary(int read_fd, int write_fd, const char mode[], double ms, uint16_t code)
{
    fprintf(stderr, "[%.3f] ", ms);

    if (code == 1)
    {
        handle_state(read_fd, write_fd, mode, ms, code);
    }
    else if (code == 2)
    {
        handle_slot(read_fd, write_fd, mode, ms, code);
    }
}

int main(int argc, char *argv[])
{
    if (argc - 1 != 2)
        errx(1, "ERROR: 2 arguments needed!");

    struct timespec start = {0, 0}, end = {0, 0};
    clock_gettime(CLOCK_MONOTONIC, &start);

    if (strcmp(argv[1], RECORD) == 0)
    {
        int fd = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, S_IRWXU);
        if (fd == -1)
            err(1, "%s", argv[2]);

        ssize_t read_size;
        uint16_t code;

        while ((read_size = read(0, &code, sizeof(code))) && read_size != -1)
        {
            clock_gettime(CLOCK_MONOTONIC, &end);
            if (code != 1 && code != 2)
                continue;

            double ms = ((double)end.tv_sec + 1.0e-9 * end.tv_nsec) - ((double)start.tv_sec + 1.0e-9 * start.tv_nsec);
            handle_binary(0, fd, RECORD, ms, code);
        }

        close(fd);
    }
    else if (strcmp(argv[1], REPLAY) == 0)
    {
        int fd = open(argv[2], O_RDONLY, S_IRWXU);
        if (fd == -1)
            err(1, "%s", argv[2]);

        ssize_t read_size;
        uint16_t code;
        double ms_recorded;

        while ((read_size = read(fd, &ms_recorded, sizeof(double))) && read_size != -1)
        {
            clock_gettime(CLOCK_MONOTONIC, &end);
            read_size = read(fd, &code, sizeof(uint16_t));
            status_check(read_size, sizeof(uint16_t), fd, 1, READ);

            if (code != 1 && code != 2)
                continue;
            double ms = ((double)end.tv_sec + 1.0e-9 * end.tv_nsec) - ((double)start.tv_sec + 1.0e-9 * start.tv_nsec);
            useconds_t wait_ms = (useconds_t)((ms_recorded - ms) * 1000000);
            usleep(wait_ms);

            struct timespec now = {0, 0};
            clock_gettime(CLOCK_MONOTONIC, &now);
            double ms_after_wait = ((double)now.tv_sec + 1.0e-9 * now.tv_nsec) - ((double)start.tv_sec + 1.0e-9 * start.tv_nsec);

            handle_binary(fd, 1, REPLAY, ms_after_wait, code);
        }

        close(fd);
    }
}
