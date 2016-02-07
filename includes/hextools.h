/* Copyright 2016 <John< */
#include <stdio.h>
#include <stdlib.h>

#ifndef HEXTOOLS_H 
#define HEXTOOLS_H 

const char* hex_to_base64(const char *input);
int hex_to_base64_from_file(FILE* in, FILE* out);
const char*  dummyMessage();
#endif // HEXTOOLS_H 
