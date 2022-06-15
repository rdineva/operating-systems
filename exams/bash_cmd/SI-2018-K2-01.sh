#!/bin/bash

# Напишете скрипт, който извежда името на потребителския акаунт, в чиято home 
# директория има най-скоро променен обикновен файл и кой е този файл. Напишете скрипта 
# с подходящите проверки, така че да бъде валиден администраторски инструмент.

find $(cut -d: -f1,6 /etc/passwd | tr : ' ') -maxdepth 1 -type f -printf "%u %f %T@\n" 2> /dev/null \
	| sort -n -k3 | tail -n 1 | cut -d" " -f1,2

exit 0
