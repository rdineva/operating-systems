#!/bin/bash

if [ ! $# -eq 5 ] && [ ! $# -eq 3 ]; then
	echo "ERROR: wrong number of arguments"
	exit 1
fi

if [ ! -f $1 ]; then
	echo "ERROR: $1 is not a file"
	exit 2
fi

file=$1 comm=$2

if [ $comm = "top_places" ]; then	
	if [ ! $# -eq 5 ]; then exit 1; fi
	if [ ! "$4" -eq "$4" ] && [ ! "$5" -eq "$5" ]; then exit 1; fi
	
	cat=$3 m=$4 n=$5
	cut -d: -f2-4 $file | grep "^$cat:[0-9]*:.*$" | sort -t: -k2 -n | awk -F ':' "$(echo '$2 >= 1 && $2 <= ')$m" | cut -d: -f3 | sort | uniq -c | sort -n -r | head -n $n
	
elif [ $comm = "parts" ]; then
	if [ ! $# -eq 3 ]; then exit 1; fi

	name=$3
	data=$(grep "$name" $file | cut -d: -f1,2)
	echo "$data" | cut -d: -f2 | sort -u | while read cat; do
		dates=$(echo "$data" | grep $cat | cut -d: -f1 | sort -n -k3 -k2 -k1 -t.)
		dates=$(echo $dates | sed 's/\([^ ]*\) /\1, /g')
		echo "$cat $dates"
	done
else
	echo "ERROR: $comm is not a valid command"
	exit 1
fi
