#!/bin/bash

[[ $# -ne 3 ]] && echo "Error: 3 args needed!" && exit 1

num_pattern="^[0-9]+.?[0-9]*$"
[[ ! $1 =~ $num_pattern ]] && echo "Error: $1 must be a valid number!" && exit 2

base_file="base.csv" prefix_file="prefix.csv"
num=$1 prefix_sym=$2 unit_sym=$3

decimal=$(grep ".*,$prefix_sym,.*" $prefix_file | cut -d, -f3)

[ -z $decimal ] && echo "Error: $prefix_sym is not in $prefix_file!" && exit 3

base_row=$(grep ".*,$unit_sym,.*" $base_file)
[ -z $base_row ] && echo "Error: $unit_sym is not in $base_file!" && exit 4

unit_name=$(echo $base_row | cut -d, -f1)
measure=$(echo $base_row | cut -d, -f3)
value=$(echo "$num*$decimal" | bc)

echo "$value $unit_sym ($measure, $unit_name)"
exit 0
