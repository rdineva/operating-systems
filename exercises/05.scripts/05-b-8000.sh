#!/bin/bash

# 05-b-8000

# Напишете shell script, който получава като единствен аргумент име на потребител
# и за всеки негов процес изписва съобщение за съотношението на RSS към VSZ.
# Съобщенията да са сортирани, като процесите с най-много заета виртуална памет са най-отгоре.

# Hint:
# Понеже в Bash няма аритметика с плаваща запетая, за смятането на съотношението използвайте командата bc. 
# За да сметнем например 24/7, можем да: echo "scale=2; 24/7" | bc
# Резултатът е 3.42 и има 2 знака след десетичната точка, защото scale=2.
# Алтернативно, при липса на bc ползвайте awk.

if [ ! $# -eq 1 ]; then
    echo "ERROR: 1 arg needed"
    exit 1
fi

if ! id -u $1 2> /dev/null; then
    echo "ERROR: no such user"
    exit 2
fi

ps -o rss,vsize --no-headers -u $1 | sort -n -k3 -r | while read line; do
    rss=$(echo $line | awk '{print $1}')
    vsize=$(echo $line | awk '{print $2}')
    echo "scale=2; $rss/$vsize" | bc
done

