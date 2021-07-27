#!/bin/bash

# 05-b-6800

# Да се напише shell скрипт, който получава единствен аргумент директория и отпечатва списък с всички файлове и директории в нея (без скритите).
# До името на всеки файл да седи размера му в байтове, а до името на всяка директория да седи броят на елементите в нея (общ брой на файловете и директориите, без скритите).

# a) Добавете параметър -a, който указва на скрипта да проверява и скритите файлове и директории.

# Пример:
# $ ./list.sh .
# asdf.txt (250 bytes)
# Documents (15 entries)
# empty (0 entries)
# junk (1 entry)
# karh-pishtov.txt (8995979 bytes)
# scripts (10 entries)

if [ ! $# -eq 1 ] && [ ! $# -eq 2 ]; then
    exit "ERROR: 1 argument needed"
    exit 1
fi

comm="ls"

if [ $# -eq 2 ]; then
    comm="ls -a"
    
    if [ $1 != "-a" ] && [ $2 != "-a" ]; then
        echo "ERROR: 1 argument needed"
        exit 2
    fi
    
    if [ ! -d $1 ] && [ ! -d $2 ]; then
        echo "ERROR: argument is not a directory"
        exit 3
    fi
    
else
    if [ ! -d $1 ]; then
        echo "ERROR: $1 is not a directory"
        exit 4
    fi
fi

$(echo $comm) | while read line; do
    if [ -f $line ]; then
        stat --format="%n (%s bytes)" $line
    fi
    
    if [ -d $line ]; then
        echo "$line ($(find $line -maxdepth 1 -type f | wc -l) entries)"
    fi
done
