#include "s21_cat.h"

int main(int argc, char *argv[]) {
  cat(argc, argv);
  return 0;
}

void cat(int argc, char *argv[]) {
  Flags flags = read_flags(argc, argv);
  int str_number = 1;
  int last_line = '\n';
  int prelast_line = 0;

  if (flags.is_stdin)
    Cat_File(stdin, flags, &str_number, &last_line, &prelast_line);
  else {
    for (int i = optind; i < argc; i++) {
      FILE *file = fopen(argv[i], "rb");
      if (file == NULL) {
        fprintf(stderr, "s21_cat: %s: No such file or directory\n", argv[i]);
      } else {
        Cat_File(file, flags, &str_number, &last_line, &prelast_line);
        fclose(file);
      }
    }
  }
}

void Cat_File(FILE *file, Flags flags, int *str_number, int *last_line,
              int *prelast_line) {
  int c;
  int cond = 0;

  if (flags.b) flags.n = 0;

  while ((c = fgetc(file)) != EOF) {
    if (flags.s && c == '\n' && *last_line == '\n') {
      cond++;
      if (cond > 1) continue;
    } else {
      cond = 0;
    }
    if (flags.b && c != '\n') {
      if (*last_line == '\n') {
        printf("%6d\t", (*str_number)++);
      }
    }

    if (flags.n && *last_line == '\n') {
      printf("%6d\t", *str_number);
      (*str_number)++;
    }

    if (flags.e && c == '\n') printf("$");
    if (flags.t && c == '\t') {
      printf("^I");
      swap(c, last_line, prelast_line);
      continue;
    }
    if (flags.v && (c < 32) && c != '\t' && c != '\n') {
      printf("^%c", c + 64);
      swap(c, last_line, prelast_line);
      continue;
    }
    if (flags.v && c == 127) {
      printf("^%c", c - 64);
      swap(c, last_line, prelast_line);
      continue;
    }
    if (flags.v && c >= 128 && c < 128 + 32) {
      printf("M-^%c", c - 64);
      continue;
    }
    if (flags.v && c >= 160 && c <= 255) {
      printf("M-%c", c - 128);
      continue;
    }
    printf("%c", c);
    swap(c, last_line, prelast_line);
  }
}

Flags read_flags(int argc, char *argv[]) {
  int valid_flag = 0;

  Flags flags = {0};

  struct option long_opt[] = {{"number-nonblank", no_argument, NULL, 'b'},
                              {"number", no_argument, NULL, 'n'},
                              {"squeeze-blank", no_argument, NULL, 's'},
                              {NULL, 0, NULL, 0}};

  while ((valid_flag = getopt_long(argc, argv, "+benstvET", long_opt, NULL)) !=
         -1) {
    switch (valid_flag) {
      case 'b':
        flags.b = 1;
        break;
      case 'v':
        flags.v = 1;
        break;
      case 'e':
        flags.v = 1;
        flags.e = 1;
        break;
      case 'n':
        flags.n = 1;
        break;
      case 's':
        flags.s = 1;
        break;
      case 't':
        flags.v = 1;
        flags.t = 1;
        break;
      case 'E':
        flags.e = 1;
        break;
      case 'T':
        flags.t = 1;
        break;
      case '?':
        fprintf(stderr, "Use --help for disply help message\n");
        exit(EXIT_FAILURE);
    }
  }
  if (!(argc - optind)) flags.is_stdin = 1;
  return flags;
}

void swap(int c, int *last_line, int *prelast_line) {
  *prelast_line = *last_line;
  *last_line = c;
}
