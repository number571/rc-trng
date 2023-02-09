#include <stdio.h>
#include <stdint.h>

void print_bin(uint8_t num);

int main(int argc, char *argv[]) {
    if (argc != 2) {
        return 1;
    }
	FILE *input = fopen(argv[1], "rb");
    if (input == NULL) {
        return 2;
    }
    int ch;
    while((ch=fgetc(input))!= EOF) {
        print_bin(ch);
    }
    fclose(input);
    printf("\n");
	return 0;
}

void print_bin(uint8_t num) {
	for (int bit = 0x80; bit > 0; bit /= 2) {
		printf("%d",(num&bit)?1:0);
	} 
}
