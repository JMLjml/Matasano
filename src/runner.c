#include <stdio.h>
#include "includes/hextools.h"

int main(int argc, char *argv[]) {
    printf("Inside of main.\n");
    const char* output = hex_to_base64(argv[0]);
    printf("%s", output);

    if(argc == 1) {
        /* no input or output files supplies */
        hex_to_base64_from_file(stdin, stdout);
    }
    return 0;
}
