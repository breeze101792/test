# Compiler and flags
CC = gcc

# Build type: release, debug, or test (default)
# Usage: make BUILD=debug or just make
BUILD ?= test

ifeq ($(BUILD), debug)
    CFLAGS = -Wall -Wextra -g -O0 -DDEBUG
else ifeq ($(BUILD), test)
    CFLAGS = -Wall -Wextra -g -O0 -DTEST
else
    CFLAGS = -Wall -Wextra -O3
endif

# Directories
SRC_DIR = src
INC_DIR = inc
OBJ_DIR = obj

# Target executable name
TARGET = main

# Source and object files
# This will find all .c files in the src directory
SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
# Dependency files for automatic header tracking
DEPS = $(OBJS:.o=.d)

# Include flags
IFLAGS = -I$(INC_DIR)

# Default target
all: $(TARGET)

# Link object files to create the executable
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

# Compile source files into object files
# -MMD -MP generates dependency files (.d) to track header changes automatically
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) $(IFLAGS) -MMD -MP -c $< -o $@

# Create object directory if it doesn't exist
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Include the dependency files
-include $(DEPS)

# Clean up build artifacts
clean:
	rm -rf $(TARGET) $(OBJ_DIR)

.PHONY: all clean
