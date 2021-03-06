#!/bin/bash

# Зад. 11 2019-SE-02
# Вие сте асистент по ОС. На първото упражнение казвате на студентите да си напишат данните на лист,
# взимате го и им правите акаунти. След упражнението обаче, забравяте да вземете листа със себе си -
# сещате се половин час по-късно, когато трябва да въведете имената на студентите в таблица, но за
# зла беда в стаята вече няма ни помен от листа (вероятно иззет от спешния отряд на GDPR-полицията)

# Сещате се, че в началото на упражнението UNIX-часовникът е показвал 1551168000 (1614246788),
# а в края 1551176100 (1617903199).

# Напишете команда, която изкарва разделени с таб факултетните номера и имената на потребителите
# от специалност СИ, чиито home директории са променили статуса си (status change time) в зададения времеви интервал.

# Приемете, че всички потребители от СИ имат home директории под /home/SI.

# Примерен изход:
# 62198   Ivaylo Georgiev
# 62126   Victoria Georgieva
# 62009   Denitsa Dobreva
# 62208   Trayana Nedelcheva

# Няколко реда от/etc/passwd за справка:
# s62136:x:1302:503:Alexander Ignatov, SI, 2, 2:/home/KN/s62136:/bin/bash
# s62171:x:1031:504:Deivid Metanov:/home/SI/s62171:/bin/bash
# s62126:x:1016:504:Victoria Georgieva:/home/SI/s62126:/bin/bash
# s62009:x:1170:504:Denitsa Dobreva,SI,3,3:/home/SI/s62009:/bin/bash
# s62196:x:1221:504:Elena Tuparova,SI,2,1:/home/SI/s62196:/bin/bash


egrep ".*$(cut -d : -f6 /etc/passwd | egrep "/home/students/.*" | xargs -I @ sh -c 'stat @ --printf="%n %Z\n"' | sort -n -k2 | awk '{if ($2 <= 1617903199 && $2 >= 1614246788) print $1}').*" /etc/passwd | cut -d : -f1,5 | cut -d , -f1 | sed 's/^s\(.*\)$/\1/g' | tr : '\t'
