#include <gtest/gtest.h>
//#include "includes/hextools.h"
#include "src/hextools.c"

class HexToolsTests : public ::testing::Test {
};

TEST_F(HexToolsTests, dummyMessage) {
    const char* expected = "My Name is hex_to_base64.\n";
    ASSERT_STREQ(expected, dummyMessage());
}
