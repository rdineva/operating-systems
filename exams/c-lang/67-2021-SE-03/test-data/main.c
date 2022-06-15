#include "../output.h"
#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("Array size: %d\n", arrN);
    for(uint32_t i = 0; i < arrN; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");

    exit(0);
}