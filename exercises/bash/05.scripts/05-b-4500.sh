#!/bin/bash

# Да се напише shell скрипт, който получава при стартиране като параметър в командния ред идентификатор на потребител. 
# Скриптът периодично (sleep(1)) да проверява дали потребителят е log-нат, и ако да - да прекратява изпълнението си, 
# извеждайки на стандартния изход подходящо съобщение.
# NB! Можете да тествате по същият начин като в 05-b-4300.txt

read -p "Enter user id: " uid

[ ! $(id -u $uid) ] && echo "ERROR: no user with id $uid" && exit 1

while true; do
	echo "Checking if user $uid is logged in..."
	if [ $(w | grep "^$uid" | wc -l) -ge 1 ]; then
		echo "User is logged in!"
		sleep 1
		continue
	else
		echo "User is not logged in!"
		echo "Exiting..."
		exit 0
	fi
done
