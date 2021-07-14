#!/bin/bash

# 05-b-4800

# Да се напише shell скрипт, който приема файл и директория. Скриптът проверява в подадената
# директория и нейните под-директории дали съществува копие на подадения файл и отпечатва
# имената на намерените копия, ако съществуват такива.
# NB! Под 'копие' разбираме файл със същото съдържание.

if [ ! $# -eq 2 ]; then
    echo "ERROR: not enough params"
    exit 1
fi

if [ ! -f $1 ]; then
    echo "ERROR: $1 is not a file"
    exit 2
fi

if [ ! -d $2 ]; then
    echo "ERROR: $2 is not a directory"
    exit 3
fi


find . -type f | while read line; do
    if [ $(diff $1 $line | wc -l) -eq 0 ]; then
        echo $line
    fi
done
