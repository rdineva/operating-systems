#!/bin/bash

# Напишете shell script, който автоматично да попълва файла указател от предната задача по 
# подадени аргументи: име на файла указател, пълно име на човека 
# (това, което очакваме да е в /etc/passwd) и избран за него nickname.

# Файлът указател нека да е във формат:
# <nickname, който лесно да запомните> <username в os-server>
# // може да сложите и друг delimiter вместо интервал

# Примерно извикване:
# ./pupulate_address_book myAddressBook "Ben Dover" uncleBen

# Добавя към myAddressBook entry-то:
# uncleBen <username на Ben Dover в os-server>

# ***Бонус: Ако има няколко съвпадения за въведеното име (напр. има 10 човека Ivan Petrov в /etc/passwd), 
# всички те да се показват на потребителя, заедно с пореден номер >=1,
# след което той да може да въведе някой от номерата (или 0 ако не си хареса никого), 
# и само избраният да бъде добавен към указателя.

[ ! $# -eq 3 ] && echo "ERROR: 3 params needed" && exit 1

[ ! -f $1 ] && echo "ERROR: $1 is not a file" && exit 2

lines=$(grep "$2" /etc/passwd)
username=$(echo -e "$lines" | cut -d: -f1)
results_count=$(echo -e "$lines" | wc -l)

if [ $results_count -gt 1 ]; then
	echo "Results matching $2:"
	echo "Choose number of user of 0 to exit."
	echo -e "$lines" | awk '{ print NR ": " $0 }' 
	read -p "Enter number of chosen user: " number
	
	[ $number -eq 0 ] && echo "Exiting..." && exit 0

	username=$(echo -e "$username" | head -n $number | tail -n 1)
fi

echo "$3 $username" >> $1
exit 0

