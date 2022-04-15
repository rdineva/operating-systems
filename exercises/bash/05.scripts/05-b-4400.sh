#!/bin/bash

# 05-b-4400

# Напишете shell script, който да приема параметър име на директория, от която взимаме файлове,
# и опционално експлицитно име на директория, в която ще копираме файлове. Скриптът да копира
# файловете със съдържание, променено преди по-малко от 45 мин, от първата директория във втората директория.
# Ако втората директория не е подадена по име, нека да получи такова от днешната дата във формат, който ви е удобен.
# При желание новосъздадената директория да се архивира.

[ $# -ne 1 ] && [ $# -ne 2 ] && echo "ERROR: 1 or 2 params needed" && exit 1

[ ! -d $1 ] && echo "ERROR: $1 is not a directory" && exit 2

[ $# -eq 2 ] && [ ! -d $2 ] && echo "ERROR: $2 is not a directory" && exit 3

dest=$2
src=$1

if [ ! $# -eq 2 ]; then
	dest=$(date +"%d-%m-%y %H:%M:%S" | tr ' ' '_')
   	mkdir $dest
fi

cp $(find $src -maxdepth 1 -type f -cmin -45) $dest
tar -cf "$dest.tar" $dest

### OLDER SOLUTION

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
