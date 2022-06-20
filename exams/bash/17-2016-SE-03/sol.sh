#!/bin/bash

# not finished

[[ $(whoami) != "root" ]] && echo "Error: user must be root" && exit 1

while read line; do
	user=$(echo $line | cut -d: -f1)
	homedir=$(echo $line | cut -d: -f2)
	
	[[ ! -d $homedir ]] && echo "$user" && continue

	[[ $(echo $homedir | wc -l) -eq 0 ]] && echo $user && continue

	w_perm=$(stat -c '%A' $homedir | head -c 3 | tail -c 1)
	if [ $w_perm == "w"]; then
		if [ "$(stat -c '%U' $homedir)" == $user ]; then
			continue
		fi
	fi

	fgroup=$(stat -c "%G" "${homedir}")
	ugroups=$(id -nG "${user}")

	if [ "${groups}" =~ ".*\<${fgroup}\>.*"]; then
				
	fi

	if [ "$(stat -c '%A' $homedir | tail -c 2 | head -c 1)" == "w"]; then
		continue		
	fi	

	echo $user
done < <(cut -d: -f1,6 /etc/passwd)
