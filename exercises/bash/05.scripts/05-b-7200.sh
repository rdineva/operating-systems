#!/bin/bash

# 05-b-7200

# Да се напише shell скрипт, който приема произволен брой аргументи - имена на файлове или директории.
# Скриптът да извежда за всеки аргумент подходящо съобщение:
#     - дали е файл, който може да прочетем
#     - ако е директория - имената на файловете в нея, които имат размер, по-малък от броя на файловете в директорията.

if [ ! $# -ge 1 ]; then
    echo "ERROR: no args provided"
    exit 1
fi

cnt=$#

for i in $(seq 1 $cnt); do
    arg=$(eval echo \${$i})
    
    if [ -d $arg ]; then
        files=$(find $arg -maxdepth 1 -type f)
        files_count=$(echo $files | wc -l)
        
        echo $files | tr ' ' '\n' | while read file; do
            size=$(stat --format="%s" $file)
            
            if [ $size -lt $files_count ]; then
                echo $file
            fi
        done
        elif [ -f $arg ]; then
        if [ -r $arg ]; then
            echo $arg
        fi
    fi
done
