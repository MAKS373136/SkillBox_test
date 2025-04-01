#ifndef S21_CAT_H
#define S21_CAT_H

#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  int b;
  int e;
  int n;
  int s;
  int t;
  int v;
  int is_stdin;
} Flags;

void cat(int argc, char *argv[]);
void Cat_File(FILE *file, Flags flags, int *str_number, int *last,
              int *prelast);
Flags read_flags(int argc, char *argv[]);
void swap(int c, int *last, int *prelast);

#endif  // S21_CAT_H