#!/bin/bash


cd cat/

clang-format -style=Google -Werror -n *.c *.h

cd ../grep/

clang-format -style=Google -Werror -n *.c *.h