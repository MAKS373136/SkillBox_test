CC=gcc
CFLAGS=-Wall -Wextra -Werror -std=c11
TEST_FLAGS=-lcheck
CLANG_PATH=../../materials/linters/
OBJS = s21_cat.o
TARGET = s21_cat
TEST_SCRIPT=test_cat.sh

.PHONY: all clean test check format clang_replace rebuild

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@
	@rm -f $(OBJS)  # Удаляем .o файлы после сборки

%.o: %.c s21_cat.h
	$(CC) $(CFLAGS) -c $< -o $@

test: $(TARGET)
	@chmod +x $(TEST_SCRIPT)
	@./$(TEST_SCRIPT)

clean:
	rm -rf *.o *.out *.a $(TARGET) .clang-format \
        test_output.txt cat_output.txt s21_output.txt

check:
	cppcheck --enable=all --suppress=missingIncludeSystem .

format:
	cp $(CLANG_PATH).clang-format ./
	clang-format -n *.c *.h

clang_replace:
	cp $(CLANG_PATH).clang-format ./
	clang-format -i *.c *.h

rebuild: clean all