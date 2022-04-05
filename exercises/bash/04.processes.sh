#!/bin/bash

# 04-a-5000
# Намерете командите на 10-те най-стари процеси в системата.
ps h -e -o comm,etimes | sort -k2 -nr | head -n 10 | cut -d' ' -f1

# 04-a-6000
# Намерете PID и командата на процеса, който заема най-много виртуална памет в системата.
ps h -eo pid,vsize,comm | sort -n -k2 | tail -n 1 | cut -d ' ' -f2,4
v2022: ps h -eo vsz,pid,comm | sort -nr -k1 | head -1 | awk '{print $2 " " $3}'

# 04-a-6300
# Изведете командата на най-стария процес
ps h -eo pid,etimes,comm | sort -n -k 2 | tail -n 1 | awk '{print $3}'

# 04-b-5000
# Намерете колко физическа памет заемат всички процеси на потребителската група root.
ps h -e -o pgrp,comm,size | awk 'BEGIN {memory=0} { if($1==0) memory+=$3 } END {print memory}'
v2022: ps -G root -o vsz | awk '{max+=$1} END {print max}'

# 04-b-6100
# Изведете имената на потребителите, които имат поне 2 процеса, чиято команда е vim (независимо какви са аргументите й)
ps -aux | grep vim | awk '{print $1}' | sort | uniq -c | grep '^.*[2-9] .*$' | awk '{print $2}'
v2022: ps -eo comm,user | grep 'vim' | sort -k2 | uniq -c | awk '$1 >= 2 {print $3}'

# 04-b-6200 v2022
# Изведете имената на потребителите, които не са логнати в момента, но имат живи процеси

# 04-b-7000
# Намерете колко физическа памет заемат осреднено всички процеси на потребителската група root. Внимавайте, когато групата няма нито един процес.
ps h -G root -o vsz | awk '{sum+=$1; cnt++} END { if (cnt > 0) { print sum/cnt } else { print 0}}'

# 04-b-8000
# Намерете всички PID и техните команди (без аргументите), които нямат tty, което ги управлява. 
ps h -eo pid,comm,tty | awk '$3 == "?" { print $1 " " $2 }'
# Изведете списък само с командите без повторения.
ps h -eo pid,comm,tty | awk '$3 == "?" { print $2 }' | sort -u

# 04-b-9000
# Да се отпечатат PID на всички процеси, които имат повече деца от родителския си процес.
ps -eo pid,ppid | cut -d ' ' -f1 | sort -n -u
