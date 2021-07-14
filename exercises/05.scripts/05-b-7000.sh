#!/bin/bash

# 05-b-7000

# Да се напише shell скрипт, който приема произволен брой аргументи - имена на файлове.
# Скриптът да прочита от стандартния вход символен низ и за всеки от зададените файлове
# извежда по подходящ начин на стандартния изход броя на редовете, които съдържат низа.
# NB! Низът може да съдържа интервал.

cnt=$#

for i in $(seq 1 $cnt); do
    arg=$(eval echo \${$i})
    if [ ! -f $arg ]; then
        echo "ERROR: $arg is not a file"
        exit 1
    fi
done

read -p "Enter string: " str

for i in $(seq 1 $cnt); do
    grep "$str" $(eval echo \${$i}) | wc -l
done
