#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

int main() {
    srand(5);

    const int n = 4096;
    uint8_t gamma[n];

    for (int i = 0; i < n; ++i) {
        gamma[i] = rand()%256;
    }

    fwrite(gamma, sizeof(uint8_t), n, stdout);
}
