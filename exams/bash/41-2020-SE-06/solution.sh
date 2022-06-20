#!/bin/bash

[[ $# -ne 3 ]] && echo "Error: 3 args needed!" && exit 1

file=$1 key=$2 value=$3
date=$(date)

if [ $(grep "^ *$key *=" $file | wc -l) -eq 0 ]; then
	echo "$key = $value # added at $date by $(id -un)" >> $file
elif [ $(grep "^ *$key *= *[^($value)]" $file | wc -l) -eq 1 ]; then
	sed -i "s/\(^ *$key *=.*\)/# \1 # edited at $date by $(id -un)\n\
$key = $value # added at $date by $(id -un)/g" $file
fi

exit 0

