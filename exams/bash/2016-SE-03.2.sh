# Зад. 18 2016-SE-03
# В текущата директория има само обикновени файлове (без директории).
# Да сенапише bash script, който приема 2 позиционни параметъра – числа,
# който мести файловете от текущата директория към нови директории
# (a, b и c, които трябва да бъдат създадени), като определен файл
# се мести към директория ’a’, само ако той има по-малко редове от първи
# позиционен параметър, мести към директория ’b’, ако редове са между първи
# и втори позиционен параметри в ’c’ в останалите случаи.


#!/bin/bash

if [ ! $# -eq 2 ]; then
    echo "ERROR: 2 args needed"
    exit 1
fi

if ! [ $1 -eq $1 ] 2> /dev/null || ! [ $2 -eq $2 ] 2> /dev/null; then
    echo "ERROR: arguments must be 2 numbers"
    exit 2
fi

mkdir {a,b,c}

find . -type f | while read file; do
    lines=$(wc -l $file | cut -d" " -f1)

    if [ $lines -lt $1  ]; then
        cp $file "a"
        echo "Copying $file with $lines to a"
    elif [ $lines -ge $1 ] && [ $lines -le $2 ]; then
        cp $file "b"
        echo "Copying $file with $lines to b"
    else
        cp $file "c"
        echo "Copying $file with $lines to c"
    fi
done
