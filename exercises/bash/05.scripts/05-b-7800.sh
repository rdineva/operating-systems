#!/bin/bash

# 05-b-7800

# Да се напише shell скрипт, който намира броя на изпълнимите файлове в PATH.
# Hint: Предполага се, че няма спейсове в имената на директориите
# Hint2: Ако все пак искаме да се справим с този случай, да се разгледа IFS променливата
# и констуркцията while read -d

if [ ! $# -eq 0 ]; then
    echo "ERROR: no args needed"
    exit 1
fi

cnt=0

echo $PATH | tr ':' '\n' | while read path; do
    ls $path | while read file; do
        if [ -x $file ]; then
            cnt=$(($cnt+1))
        fi
    done
done

echo $cnt

# output always 0

# Easier solution:
find . -type f -executable | wc -l
