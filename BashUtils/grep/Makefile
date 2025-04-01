NAME = s21_grep
CC = gcc
SRC = s21_grep.c process.c utils.c
HEADERS = s21_grep.h
OBJS = $(patsubst %.c, %.o, $(SRC))
DIR_OBJS = objs
PATH_OBJS = $(addprefix $(DIR_OBJS)/, $(OBJS))
CFLAGS = -Wall -Wextra -Werror -g -std=c11 -D_GNU_SOURCE -D_POSIX_C_SOURCE=200809L
TEST_SCRIPT = test_grep.sh
CLANG_PATH = ../../materials/linters/

.PHONY: all clean test check format clang_replace rebuild

all: $(NAME)

$(NAME): $(PATH_OBJS)
	$(CC) $(CFLAGS) $^ -o $@
	@rm -f $(PATH_OBJS)

$(DIR_OBJS)/%.o: %.c $(HEADERS) Makefile
	@mkdir -p $(DIR_OBJS)
	$(CC) $(CFLAGS) -c $< -o $@

test: $(NAME)
	@chmod +x $(TEST_SCRIPT)
	@./$(TEST_SCRIPT)

clean:
	rm -rf $(DIR_OBJS) $(NAME) *.txt *.bin
	rm -rf .clang-format

check:
	cppcheck --enable=all --suppress=missingIncludeSystem .

format:
	cp $(CLANG_PATH).clang-format ./
	clang-format -n *.c *.h

clang_replace:
	cp $(CLANG_PATH).clang-format ./
	clang-format -i *.c *.h

rebuild: clean all