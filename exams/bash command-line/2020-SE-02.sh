#!/bin/bash

# Зад. 14 2020-SE-02
# Даден е текстовият файл spacex.txt, който съдържа информация за полети на ракети на SpaceX.
# На всеки ред има информация за един такъв полет в следните колони, разделени с вертикална черта ’|’:
# дата на полета в UNIX формат
# Космодрум
# успешност на полета (две възможни стойности)–Success- успешен полет–Failure- неуспешен полет
# полезен товар

# Първият ред във файла e header, който описва имената на колоните. Данните във файла не са сортирани.
# Намерете и изведете разделени с двоеточие (’:’) успешността и информацията за полезния товар на
# най-скорошния полет, който е изстрелян от космодрума с най-много неуспешни полети.

# Примерен входен файл:
# date|launch site|outcome|payload
# 1291759200|CCAFS|Success|Dragon demo flight and cheese
# 1435438800|CCAFS|Failure|SpaceX CRS-72
# 1275666300|CCAFS|Success|Dragon Spacecraft Qualification Unit
# 1452981600|VAFB|Success|Jason-3
# 1498165200|KSC|Success|BulgariaSat-1
# 1473454800|CCAFS|Failure|Amos-6
# 1517868000|KSC|Success|Elon Musk’s Tesla
# 1405285200|CCAFS|Success|Orbcomm


cat spacex | tail -n +2 | egrep ".*\|$(cat spacex | tail -n +2 | egrep "^.*\|.*\|Success\|.*$" | cut -d "|" -f2 | sort | uniq -c | head -n 1 | awk '{print $2}')\|.*\|.*" | sort -n -r -k1 | head -n 1 | tr "|" " " | awk '{print $3":"$4}'
