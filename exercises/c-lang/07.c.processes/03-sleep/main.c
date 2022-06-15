// Да се напише програма на C, която изпълнява команда sleep (за 60 секунди).

#include <unistd.h>
#include <err.h>

int main() {    
    if (execl("/bin/sleep", "sleep", "60", (char*)NULL) == -1) {
        errx(1, "couldn't exec sleep");
    }
}
