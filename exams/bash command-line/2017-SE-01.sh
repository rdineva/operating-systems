#!/bin/bash

# Зад. 6 2017-SE-01
# Намерете имената на топ 5 файловете в текущата директория с най-много hardlinks.


find . -type f -exec ls -l {} \; | sort -t ' ' -k 2 -r | head -n 5 | cut -d ' ' -f 10
