#!/bin/bash

# 05-b-7100

# Да се напише shell скрипт, който приема два параметъра - име на директория и число.
# Скриптът да извежда на стандартния изход имената на всички обикновени файлове в директорията,
# които имат размер, по-голям от подаденото число.

if [ ! $# -eq 2 ]; then
    echo "ERROR: 2 args needed"
    exit 1
fi

if [ ! -d $1 ]; then
    echo "ERROR: $1 is not a directory"
    exit 2
fi

if ! [ $2 -eq $2 ]; then
    echo "ERROR: $2 must be an integer"
    exit 3
fi

find $1 -maxdepth 1 -type f | xargs -I @ sh -c 'stat --format="%n %s" @' | while read line; do
    name=$(echo $line | cut -d " " -f1)
    size=$(echo $line | cut -d " " -f2)
    
    if [ $size -gt $2 ]; then
        echo $name
    fi
done
