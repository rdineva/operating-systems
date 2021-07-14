#!/bin/bash

# 05-b-9100

# Опишете поредица от команди или напишете shell скрипт, които/който при известни две директории SOURCE и DESTINATION:
# - намира уникалните "разширения" на всички файлове, намиращи се някъде под SOURCE.
# (За простота приемаме, че в имената на файловете може да се среща символът точка '.' максимум веднъж.)
# - за всяко "разширение" създава по една поддиректория на DESTINATION със същото име
# - разпределя спрямо "разширението" всички файлове от SOURCE в съответните поддиректории в DESTINATION

if [ ! $# -eq 2 ]; then
    echo "ERROR: 2 args needed"
    exit 1
fi

if [ ! -d $1 ]; then
    echo "ERROR: $1 is not a dir"
    exit 2
fi

if [ ! -d $2 ]; then
    echo "ERROR: $2 is not a dir"
    exit 2
fi

src=$1
dest=$2

find $src -maxdepth 1 -type f 2> /dev/null | cut -d "/" -f2 | egrep ".+\.[^\.]*$" | tr ' ' '\n' | while read file; do
    ext=$(echo $file | cut -d . -f2 | sort -u)
    if [ ! -d "$dest/$ext" ]; then
        mkdir "$dest/$ext"
    fi
    
    mv $file "$dest/$ext"
done
