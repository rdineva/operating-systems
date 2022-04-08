#!/bin/bash

# Имате компилируем (a.k.a няма синтактични грешки) source file на езика C. 
# Напишете shell script, който да покaзва колко е дълбоко най-дълбокото nest-ване (влагане).
# Примерен .c файл:

# #include <stdio.h>
# 
# int main(int argc, char *argv[]) {
#
#   if (argc == 1) {
# 		printf("There is only 1 argument");
# 	} else {
# 		printf("There are more than 1 arguments");
# 	}
# 
# 	return 0;
# }
# Тук влагането е 2, понеже имаме main блок, а вътре в него if блок.

# Примерно извикване на скрипта:
# ./count_nesting sum_c_code.c

# Изход:
# The deepest nesting is 2 levels


max=0
curr=0

while read -r line; do
	[ $(echo $line | grep "{" | wc -l) -eq 1 ] && curr=$(($curr+1))
	[ $(echo $line | grep "}" | wc -l) -eq 1 ] && curr=$(($curr-1))
	[ $curr -gt $max ] && max=$curr   	
done < <(cat $1)

echo "The deepest nesting is $max levels"
