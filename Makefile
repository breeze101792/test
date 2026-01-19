# Compiler and flags
CXX = bear -- g++

# Build type: release, debug, or test (default)
# Usage: make BUILD=debug or just make
BUILD ?= devl

ifeq ($(BUILD), devl)
    CXXFLAGS = -g -O0 -DTEST
else ifeq ($(BUILD), debug)
    CXXFLAGS = -Wall -Wextra -g -O0 -DDEBUG -Wno-unused-parameter -Wno-unused-variable
else ifeq ($(BUILD), release)
    CXXFLAGS = -Wall -Wextra -O3
else
    $(error "Error build config, You must define make BUILD=(devl|debug|release) to build!")
endif

# Directories
SRC_DIR = src
INC_DIR = inc
OBJ_DIR = obj

# Target executable name
TARGET = main

# Source and object files
# This will find all .cpp files in the src directory
SRCS = $(wildcard $(SRC_DIR)/*.cpp)
OBJS = $(SRCS:$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%.o)
# Dependency files for automatic header tracking
DEPS = $(OBJS:.o=.d)

# Include flags
IFLAGS = -I$(INC_DIR)

# Default target
all: $(TARGET)

# Link object files to create the executable
$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJS)

# Compile source files into object files
# -MMD -MP generates dependency files (.d) to track header changes automatically
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) $(IFLAGS) -MMD -MP -c $< -o $@

# Create object directory if it doesn't exist
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Include the dependency files
-include $(DEPS)

# Clean up build artifacts
clean:
	rm -rf $(TARGET) $(OBJ_DIR)

test: main
	@echo "================================================="
	@./main
	@echo "================================================="

rebuild: clean main
	echo "Rebuild"

debug: main
	gdb -q -tui ./main

.PHONY: all clean test rebuild gdb
