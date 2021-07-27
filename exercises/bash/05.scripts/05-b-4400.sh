#!/bin/bash

# 05-b-4400

# Напишете shell script, който да приема параметър име на директория, от която взимаме файлове,
# и опционално експлицитно име на директория, в която ще копираме файлове. Скриптът да копира
# файловете със съдържание, променено преди по-малко от 45 мин, от първата директория във втората директория.
# Ако втората директория не е подадена по име, нека да получи такова от днешната дата във формат, който ви е удобен.
# При желание новосъздадената директория да се архивира.

if [ ! $# -eq 1 ] && [ ! $# -eq 2 ]; then
    echo "ERROR: Incorrect number of params."
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "$1 is not a directory"
    exit 2
fi

if [ $# -eq 2 ] && [ ! -d "$2" ]; then
    echo "$2 is not a directory"
fi

result_dir=""

if [ $# -eq 2 ]; then
    result_dir=$2
else
    result_dir=$(date '+%Y-%m-%d')
    mkdir $result_dir
fi

src_dir=$1

find $src_dir -maxdepth 1 -type f -mmin -45 | while read line; do
    cp $line "$result_dir"
done

tar -cf "$result_dir.tar" $result_dir
