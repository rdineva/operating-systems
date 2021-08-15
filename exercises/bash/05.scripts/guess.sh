#!/bin/bash

# 05-b-7500

# Напишете shell script guess, която си намисля число, което вие трябва да познате.
# В зависимост от вашия отговор, програмата трябва да ви казва "надолу" или "нагоре",
# докато не познате числото. Когато го познаете, програмата да ви казва с колко опита сте успели.
# ./guess (програмата си намисля 5)

# Guess? 22
# ...smaller!
# Guess? 1
# ...bigger!
# Guess? 4
# ...bigger!
# Guess? 6
# ...smaller!
# Guess? 5
# RIGHT! Guessed 5 in 5 tries!

# Hint: Един начин да направите рандъм число е с $(( (RANDOM % b) + a  )),
# което ще генерира число в интервала [a, b]. Може да вземете a и b като параметри, но не забравяйте да направите проверката.

if [ ! $# -eq 2 ]; then
    echo "ERROR: 2 args needed"
    exit 1
fi

if [ ! $1 -eq $1 ] || [ ! $2 -eq $2 ]; then
    echo "ERROR: numbers must be integers"
    exit 2
fi

if [ $1 -gt $2 ]; then
    echo "ERROR: $1 is greater than $2"
    exit 3
fi

rand=$(((RANDOM % $2)+$1))
tries=0

while read -p "Guess? " number; do
    tries=$(($tries+1))
    if [ $number -eq $rand ]; then
        echo "Guessing correctly took you $tries tries!"
        break
    elif [ $number -gt $rand ]; then
        echo "...smaller!"
    elif [ $number -lt $rand ]; then
        echo "...bigger!"
    fi
done
