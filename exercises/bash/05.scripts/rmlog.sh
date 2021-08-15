#!/bin/bash

# 05-b-9200

# Да се напише shell скрипт, който получава произволен брой аргументи файлове, които изтрива.
# Ако бъде подадена празна директория, тя бива изтрита. Ако подадения файл е директория с поне 1 файл, тя не се изтрива.
# За всеки изтрит файл (директория) скриптът добавя ред във log файл с подходящо съобщение.

# а) Името на log файла да се чете от shell environment променлива, която сте конфигурирали във вашия .bashrc.
# б) Добавете параметър -r на скрипта, който позволява да се изтриват непразни директории рекурсивно.
# в) Добавете timestamp на log съобщенията във формата: 2018-05-01 22:51:36

# Примери:
# $ export RMLOG_FILE=~/logs/remove.log
# $ ./rmlog -r f1 f2 f3 mydir/ emptydir/
# $ cat $RMLOG_FILE
# [2018-04-01 13:12:00] Removed file f1
# [2018-04-01 13:12:00] Removed file f2
# [2018-04-01 13:12:00] Removed file f3
# [2018-04-01 13:12:00] Removed directory recursively mydir/
# [2018-04-01 13:12:00] Removed directory emptydir/

if [ $# -lt 1 ] && [ $1 == "-r" ]; then
    echo "ERROR: args needed"
    exit 1
fi

rec=0

for i in $(seq 1 $#); do
    arg=$(eval echo \${$i})
    
    if [ $arg == "-r" ]; then
        rec=1
        continue
    fi
    
    if [ ! -f $arg ] && [ ! -d $arg ]; then
        echo "ERROR: args need to be files and dirs"
        exit 2
    fi
done

for i in $(seq 1 $#); do
    arg=$(eval echo \${$i})
    
    if [ -f $arg ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removed file $arg" >> $RMLOG_FILE
        rm $arg
    elif [ -d $arg ]; then
        if [ $(ls $arg | wc -l) -eq 0 ]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removed empty directory $arg" >> $RMLOG_FILE
            rmdir $arg
        elif [ $rec -eq 1 ]; then
            rm -r $arg
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removed directory recursively $arg" >> $RMLOG_FILE
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Could not remove non-empty directory" >> $RMLOG_FILE
        fi
    fi
done
