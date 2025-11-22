# Generic Makefile for Mixed Project (C, C++, Assembly)
# Folders: src/ (Recursive), include/, bin/

TARGET := program
SRC_DIR := src
INC_DIR := include
BUILD_DIR := bin

CC       := gcc
CXX      := g++
ASM      := gcc

COMMON_FLAGS := -I$(INC_DIR) -g -Wall -Wextra
CFLAGS   := -std=c11 $(COMMON_FLAGS)
CXXFLAGS := -std=c++17 $(COMMON_FLAGS)
ASFLAGS  := $(COMMON_FLAGS)

LD       := $(CXX)
LDFLAGS  := 

SRCS_C   := $(shell find $(SRC_DIR) -name '*.c')
SRCS_CPP := $(shell find $(SRC_DIR) -name '*.cpp')
SRCS_ASM := $(shell find $(SRC_DIR) -name '*.S')

OBJS_C   := $(SRCS_C:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
OBJS_CPP := $(SRCS_CPP:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)
OBJS_ASM := $(SRCS_ASM:$(SRC_DIR)/%.S=$(BUILD_DIR)/%.o)

OBJS := $(OBJS_C) $(OBJS_CPP) $(OBJS_ASM)

all: $(TARGET)

$(TARGET): $(OBJS)
	@mkdir -p $(BUILD_DIR)
	@echo "Linking $(TARGET)..."
	$(LD) $(OBJS) -o $(BUILD_DIR)/$(TARGET) $(LDFLAGS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	@echo "Compiling C: $<"
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	@echo "Compiling C++: $<"
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.S
	@mkdir -p $(dir $@)
	@echo "Compiling ASM: $<"
	$(ASM) $(ASFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)

run: all
	./$(BUILD_DIR)/$(TARGET)

.PHONY: all clean run