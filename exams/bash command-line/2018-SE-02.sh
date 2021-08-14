#!/bin/bash

# Зад. 8 2018-SE-02
# Напишете серия от команди, извеждащи на екрана само inode-а
# на най-скоро променения (по съдържание) файл, намиращ се в home
# директорията на потребител pesho (или нейните под-директории), който има повече от едно име.


find . -type f -printf "%T@ %p %i\n" | sort -n | tail -n 1 | cut -d ' ' -f 3