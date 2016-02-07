/* Copyright 2015 <John> */
#include "includes/hextools.h"

const char* hex_to_base64(const char* input)
{
    const char* output = "hex_to_base64\n";
    return output;
}

int hex_to_base64_from_file(FILE* in, FILE* out)
{
    int c;
    while((c = getc(in)) != EOF) {
        putc(c, out);
    }

    return EXIT_SUCCESS;
}

const char*  dummyMessage()
{
    return "My Name is hex_to_base64.\n";
}
