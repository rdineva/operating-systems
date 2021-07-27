#!/bin/bash

if [ ! $# -eq 2 ]; then
    echo "ERROR: 2 args needed"
    exit 1
fi

if [ ! -f $1 ] || [ ! -f $2 ]; then
    echo "ERROR: $1 and $2 must be files"
    exit 2
fi

winner=""

file1_lines=$(egrep -o "$1" $1 | wc -l)
file2_lines=$(egrep -o "$2" $2 | wc -l)

[ $file1_lines -gt $file2_lines ] && winner=$1 || winner=$2

echo "Winner is: $winner"

cat $winner | cut -d " " -f4- | sort > "$winner.songs"
