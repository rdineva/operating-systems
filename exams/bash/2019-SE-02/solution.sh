#!/bin/bash

start=1
n=10

if [ $1 == "-n" ]; then
    n=$2
    start=3
fi

lines=""

for i in $(seq $start $#); do
    file=$(eval echo \${$i})
    IDF=$(echo $file | sed 's/\(.*\)\.log/\1/g')

    while read line; do
        timestamp=$(echo $line | cut -d " " -f1,2)
        data=$(echo $line | cut -d " " -f3-)
        new_line="${timestamp} ${IDF} ${data}\n"
        lines+=$new_line
    done < <(cat $file)
done

echo -e $lines | sort -k1 -k2 -n | awk 'NF'
