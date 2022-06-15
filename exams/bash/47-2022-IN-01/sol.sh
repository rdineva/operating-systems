#!/bin/bash

[[ $# -ne 2 ]] && echo "Error: 2 args needed!" && exit 1

if [ ! -d $1 ] || [ ! -d $2 ]; then
	echo "Error: $1 or $2 is not a directory!"
	exit 2
fi

if [ $(find $2 -mindepth 1 | wc -l) -ne 0 ]; then
	echo "Error: $2 should be empty"
	exit 3
fi

find $1 -type d | sort | while read read_dir; do
	copy_dir=$(echo $read_dir | sed "s/^[^\/]*\/\(.*\)$/$2\/\1/g")
	[[ $1 != $copy_dir ]] && mkdir -p $copy_dir || copy_dir=$2

	find $read_dir -mindepth 1 -maxdepth 1 -type f -printf "%f\n" | while read file; do
		if [ $(echo "$file" | grep ".swp$" | wc -l) -eq 0 ]; then
			cp "$read_dir/$file" $copy_dir
		else
			clean_file=$(echo "$file" | sed "s/^\.\(.*\)\.swp$/\1/g") 
			if [ $(ls "$read_dir/$clean_file" 2>/dev/null | wc -l) -eq 0 ]; then
				cp "$read_dir/$file" $copy_dir
			fi
		fi
	done 
done

exit 0
