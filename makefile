SHELL = /bin/sh 
CC = gcc # This is the main compiler
CFLAGS = -Wall -g -std=c99


# Alternately compile with clang analyze for more verbose error messages
# CC := clang --analyze

# Directory Structure Variables
SRCDIR = src
BUILDDIR = build
TESTDIR = test
TARGET = bin/runner
TESTER = bin/tester

# Source Code Variables
SRCEXT = c
TESTSRCEXT = cc
SOURCES = $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS = $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))


# Test Code Variables
TEST_SOURCES = $(shell find $(TESTDIR) -type f -name *.$(TESTSRCEXT))
TEST_OBJECTS = $(patsubst $(TESTDIR)/%,$(BUILDDIR)/%,$(TEST_SOURCES:.$(TESTSRCEXT)=.o))

# this works correctly to filter out runner.o when linking unit tests to gtest_main.a
OBJS = $(filter-out $(BUILDDIR)/runner.o, $(OBJECTS))


# Variables to point to the GTEST Directory for unit testing.
GTEST_DIR = $(HOME)/Code/gmock-1.7.0/gtest
GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h $(GTEST_DIR)/include/gtest/internal/*.h
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

# Include Directories
INC = -I .
# GTEST_INCLUDES = -I$(GTEST_DIR)/include/gtest/*.h -I$(GTEST_DIR)/include/gtest/internal/*.h -I$(GTEST_DIR)/include/
GTEST_INCLUDES = -I$(GTEST_DIR)/include/


# build the target, most likely bin/runner
$(TARGET): $(OBJECTS)
	@echo " \n *** LINKING SOURCE OBJECTS *** \n"
	@echo " $(CC) $^ -o $(TARGET) "; $(CC) $^ -o $(TARGET)

# compile the source code
$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@echo " \n *** COMPILING SOURCES *** \n"
	@echo " $(CC) $(CFLAGS) $(INC) -c -o $@ $< "; $(CC) $(CFLAGS) $(INC) -c -o $@ $<

# compile the unit tests
$(BUILDDIR)/%.o: $(TESTDIR)/%.$(TESTSRCEXT)
	@echo " \n *** COMPILING UNIT TESTS *** \n"
	@echo " $(CXX) $(CXXFLAGS) $(GTEST_INCLUDES) $(INC) -c -o $@ $< "; $(CXX) $(CXXFLAGS) $(GTEST_INCLUDES) $(INC) -c -o $@ $<

# link the unit tests
test: $(TEST_OBJECTS) $(OBJS) $(BUILDDIR)/gtest_main.a
	@echo " \n *** LINKING UNIT TESTS *** \n"
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $(TESTER)

clean:
	@echo " \n *** CLEANING *** \n" 
	rm -f $(OBJECTS) $(TEST_OBJECTS) $(TARGET) $(TESTER) $(BUILDDIR)/*.o $(BUILDDIR)/*.a





# compile the gtest part of the testing framework. 



# Just copied from sample makefile. Read and update later
# Flags passed to the preprocessor.
# Set Google Test's header directory as a system directory, such that
# the compiler doesn't generate warnings in Google Test headers.
CPPFLAGS += -isystem $(GTEST_DIR)/include
# Flags passed to the C++ compiler.
CXXFLAGS += -g -Wall -Wextra -pthread

# Builds gtest.a and gtest_main.a.
# Usually you shouldn't tweak such internal variables, indicated by a
# trailing _.
# for simplicity and to avoid depending on Google Test's
# implementation details, the dependencies specified below are
# conservative and not optimized. This is fine as Google Test
# compiles fast and for ordinary users its source rarely changes.
$(BUILDDIR)/gtest-all.o: $(GTEST_SRCS_)
	@echo "\n *** COMPILING gtest-all.cc *** \n"
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c $(GTEST_DIR)/src/gtest-all.cc -o $(BUILDDIR)/gtest-all.o

$(BUILDDIR)/gtest_main.o: $(GTEST_SRCS_)
	@echo " \n *** COMPILING gtest_main.cc *** \n"
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c $(GTEST_DIR)/src/gtest_main.cc -o $(BUILDDIR)/gtest_main.o

$(BUILDDIR)/gtest.a: $(BUILDDIR)/gtest-all.o
	@echo " \[\e[38;5;243m\ \n *** gtest.a step *** \n"
	$(AR) $(ARFLAGS) $@ $^

$(BUILDDIR)/gtest_main.a: $(BUILDDIR)/gtest-all.o $(BUILDDIR)/gtest_main.o
	@echo " \n LINKING gtest_main.a *** \n"
	$(AR) $(ARFLAGS) $@ $^

