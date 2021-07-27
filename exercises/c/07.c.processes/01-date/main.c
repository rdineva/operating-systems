// Да се напише програма на C, която изпълнява команда date.

#include <unistd.h>
#include <err.h>

int main() {
    if(execl("/bin/date", "date", (char*)NULL) == -1) {
        errx(1, "couldn't get date");
    }    
}
