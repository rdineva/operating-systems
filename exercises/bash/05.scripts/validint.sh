#!/bin/bash

# 05-b-4600

# Да се напише shell скрипт, който валидира дали дадено цяло число попада в целочислен интервал.
# Скриптът приема 3 аргумента: числото, което трябва да се провери; лява граница на интервала; дясна граница на интервала.
# Скриптът да връща exit status:
# - 3, когато поне един от трите аргумента не е цяло число
# - 2, когато границите на интервала са обърнати
# - 1, когато числото не попада в интервала
# - 0, когато числото попада в интервала

# Примери:
# $ ./validint.sh -42 0 102; echo $?
# 1

# $ ./validint.sh 88 94 280; echo $?
# 1

# $ ./validint.sh 32 42 0; echo $?
# 2

# $ ./validint.sh asdf - 280; echo $?
# 3

if [ ! $# -eq 3 ]; then
    echo "ERROR: Incorrect number of params."
    exit 4
fi

if [ $(echo "$2$3$4" | grep "\." | wc -l) -gt 0 ]; then
    echo "ERROR: Numbers should be integers."
    exit 3
fi

if [ $2 -gt $3 ]; then
    echo "Displaced margins"
    exit 2
fi

if [ $1 -gt $3 ] || [ $1 -lt $2 ]; then
    echo "Outside"
    exit 1
fi

if [ $1 -le $3 ] && [ $1 -ge $2 ]; then
    echo "Inside"
    exit 0
fi
