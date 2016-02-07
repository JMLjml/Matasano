#include <gtest/gtest.h>
#include "src/hextools.c"

class HexToolsTests : public ::testing::Test {
    protected:
        char* input = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d";
};

TEST_F(HexToolsTests, dummyMessage) {
    const char* expected = "My Name is hex_to_base64.\n";
    ASSERT_STREQ(expected, dummyMessage());
}

TEST_F(HexToolsTests, hex_to_base64) {
    const char* expected = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t";
    ASSERT_STREQ(expected, hex_to_base64(input));
}
