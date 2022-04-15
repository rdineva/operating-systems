#!/bin/bash

# 05-b-6600

# Да се напише shell скрипт, който получава единствен аргумент директория и изтрива всички повтарящи се (по съдържание) 
# файлове в дадената директория. Когато има няколко еднакви файла, да се остави само този, чието име е лексикографски 
# преди имената на останалите дублирани файлове.

# Примери:
# $ ls .
# f1 f2 f3 asdf asdf2
# # asdf и asdf2 са еднакви по съдържание, но f1, f2, f3 са уникални

# $ ./rmdup .
# $ ls .
# f1 f2 f3 asdf
# # asdf2 е изтрит

if [ ! $# -eq 1 ]; then
    echo "ERROR: needed 1 argument"
    exit 1
fi

if [ ! -d $1 ]; then
    echo "ERROR: $1 is not a directory"
    exit 2
fi

find $1 -maxdepth 1 -type f | sort | while read file1; do
    find $1 -maxdepth 1 -type f | while read file2; do
        [ $file1 == $file2 ] && continue
        [ $(diff $file1 $file2 | wc -l) -eq 0 ] && rm $file2
    done
done
