#!/bin/bash

# 04-a-5000
# Намерете командите на 10-те най-стари процеси в системата.
ps -eo etimes,comm | tail -n +2 | sort -n | tail -n 10 | cut -d ' 'f -f3

# 04-a-6000
# Намерете PID и командата на процеса, който заема най-много виртуална памет в системата.
ps h -eo pid,vsize,comm | sort -n -k2 | tail -n 1 | cut -d ' ' -f2,4

# 04-a-6300
# Изведете командата на най-стария процес
ps h -eo pid,etimes,comm | sort -n -k 2 | tail -n 1 | awk '{print $3}'

# 04-b-5000
# Намерете колко физическа памет заемат всички процеси на потребителската група root.
ps h -e -o pgrp,comm,size | awk 'BEGIN {memory=0} { if($1==0) memory+=$3 } END {print memory}'

# 04-b-6100
# Изведете имената на потребителите, които имат поне 2 процеса, чиято команда е vim (независимо какви са аргументите й)
ps -aux | grep vim | awk '{print $1}' | sort | uniq -c | grep '^.*[2-9] .*$' | awk '{print $2}'

# 04-b-7000
# Намерете колко физическа памет заемат осреднено всички процеси на потребителската група root. Внимавайте, когато групата няма нито един процес.
ps h -e -o pgrp,comm,size | awk 'BEGIN {memory=0; count=0} { if($1==0) memory+=$3; count+=1 } END {if (count >= 1) { print memory/count } else {print 0 }}'

# 04-b-8000
# Намерете всички PID и техните команди (без аргументите), които нямат tty, което ги управлява. Изведете списък само с командите без повторения.
ps -e -o pid,tty,comm | grep '^.* ? .*' | awk '{print $3}' | sort -u

# 04-b-9000
# Да се отпечатат PID на всички процеси, които имат повече деца от родителския си процес.
ps -eo pid,ppid | cut -d ' ' -f1 | sort -n -u