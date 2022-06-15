# Зад. 15 2016-SE-01
# Напишете shell скрипт, който по подаден един позиционен параметър,
# ако този параметър е директория, намира всички symlink-ове в нея и под-директориите и с несъществуващ destination.


#!/bin/bash

if [ ! $# -eq 1 ]; then
    echo "ERROR: no arg provided"
    exit 1
fi

if [ ! -d $1 ]; then
    echo "ERROR: $1 is not a dir"
    exit 2
fi

find $1 -type l 2> /dev/null
