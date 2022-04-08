#!/bin/bash

# Напишете shell script, който по подаден като аргумент файл с map
# между <nickname> -> <реален username> и nickname, 
# ще ви улесни да изпращате съобщения на хората.
# Пример за файл указател:
# tinko s61966
# minko s881234
# ginko s62000
# dinko s77777

# Примерно извикване на програмата:
# ./send_message myAddressBook dinko

# И вече може да изпращате съобщения на човека с username s77777
# NB! Можете да създавате нови потребители използвайки 'sudo useradd username'. За да проверите дали се пращат съобщенията отворете 2 сесии към виртуалката ви, създайте новият потребител, логнете се с него ( 'sudo su username' от едната сесия ) и от другата сесия пратете съобщението.


[ ! $# -eq 2 ] && echo "ERROR: 2 params needed" && exit 1

user=$(grep "^$2" $1 | cut -d" " -f2)

! id -u $user &> /dev/null && echo "ERROR: user $2 doesn't exist in address book" && exit 2 

write $user 
