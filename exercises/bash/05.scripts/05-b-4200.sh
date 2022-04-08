#!/bin/bash

max=0
curr=0

while read -r line; do
	[ $(echo $line | grep "{" | wc -l) -eq 1 ] && curr=$(($curr+1))
	[ $(echo $line | grep "}" | wc -l) -eq 1 ] && curr=$(($curr-1))
	[ $curr -gt $max ] && max=$curr   	
done < <(cat $1)

echo "The deepest nesting is $max levels"
