#!/bin/bash

# a
file=$(mktemp)

ps -e -o user=,pid=,time= > $file

foo_ps=$(egrep $1 $file | wc -l)

awk '{ print $1 }' $file | sort | uniq -c | awk -v user_p=$foo_ps '$1 > $user_p { print $2 }'

# b
seconds=$(cat $file | tr : ' ' | awk '{ total += $5 + $4*60 + $3*60*60 } END { print total/NR }')
echo $seconds

# c
egrep $1 $file | tr : ' ' | awk -v t=$seconds '$5 + $4*60 + $3*60*60 > 2*$seconds { print $2 }' | xargs kill 

