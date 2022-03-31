#!/bin/bash

# 03-a-0200
# Сортирайте /etc/passwd лексикографски по поле UserID.
sort -k 3 -t ":" /etc/passwd

# 03-a-0201
# Сортирайте /etc/passwd числово по поле UserID.
# (Открийте разликите с лексикографската сортировка)
sort -k 3 -t ":" -n /etc/passwd

# 03-a-2100
# Изведете само 1-ва и 5-та колона на файла /etc/passwd спрямо разделител ":".
cut -f 1,5 -d ":" /etc/passwd

# 03-a-0211
# Изведете съдържанието на файла /etc/passwd от 2-ри до 6-ти символ.
cut -c 2-6 /etc/passwd | head -n 1

# 03-a-0212
# Отпечатайте потребителските имена и техните home директории от /etc/passwd.
cut -d: -f1,6 /etc/passwd

# 03-a-0213
# Отпечатайте втората колона на /etc/passwd, разделена спрямо символ '/'.
cut -d'/' -f2 /etc/passwd

# 03-a-1500
# Изведете броя на байтовете в /etc/passwd.
# Изведете броя на символите в /etc/passwd.
# Изведете броя на редовете  в /etc/passwd.
wc -c /etc/passwd
wc -m /etc/passwd
wc -l /etc/passwd

# 03-a-2000
# Извадете от файл /etc/passwd:
# - първите 12 реда
head -n 12 /etc/passwd
# - първите 26 символа
cut -c 1-26 /etc/passwd | head -n 1
# - всички редове, освен последните 4
head -n -4 /etc/passwd
# - последните 17 реда
tail -n 17 /etc/passwd
# - 151-я ред (или друг произволен, ако нямате достатъчно редове)
head -n 152 /etc/passwd | tail -n 1
# - последните 4 символа от 13-ти ред
cat /etc/passwd | head -n 14 | tail -n 1 | egrep -o '.{4}$'
or: head -n 13 /etc/passwd | tail -n 1 | rev | cut -c1-4 | rev

# 03-a-2100
# Отпечатайте потребителските имена и техните home директории от /etc/passwd.
cut -d ":" -f 3,6 /etc/passwd

# 03-a-3000
# Запаметете във файл в своята home директория резултатът от командата ls -l изпълнена за вашата home директорията.
# Сортирайте създадения файла по второ поле (numeric, alphabetically).
ls -l > home
sort -n -k 2 home
sort -k 2 home

# 03-a-3000 v2022
# Запаметете във файл в своята home директория резултатът от командата `df -P`.
# Напишете команда, която извежда на екрана съдържанието на този файл, без първия ред (хедъра), сортирано по второ поле (numeric).
tail -n +2 file | sort -n -k2

# 03-a-3001 v2022
# Запазете само потребителските имена от /etc/passwd във файл users във вашата home директория.
cut -d: -f1 /etc/passwd > users

# 03-a-3500
# Изпишете всички usernames от /etc/passwd с главни букви.
cut -d: -f1 /etc/passwd | sed 's/\([a-z]\)/\U\1/g'

# 03-a-5000
# Отпечатайте 2 реда над вашия ред в /etc/passwd и 3 реда под него // може да стане и без пайпове
grep -B 2 -A 3 's<fn>' /etc/passwd

# 03-a-5000 v2022
# Изведете реда от /etc/passwd, на който има информация за вашия потребител.
grep 's<fn>' /etc/passwd

# Изведедете този ред и двата реда преди него.
grep -B 2 's<fn>' /etc/passwd

# Изведете този ред, двата преди него, и трите след него.
grep -A 3 -B 2 's<fn>' /etc/passwd

# Изведете *само* реда, който се намира 2 реда преди реда, съдържащ информация за вашия потребител.
grep -B 2 's<fn>' /etc/passwd | head -n 1


# 03-a-5001
# Колко хора не се казват изпозват /bin/bash за login shell  според /etc/passwd (hint: 'man 5 passwd' за информация какъв е форматът на /etc/passwd)
cut -d ":" -f 7 /etc/passwd | grep -v '/bin/bash' | wc -l

# 03-a-5002
# Изведете само имената на хората с второ име по-дълго от 6 (>6) символа според /etc/passwd
cat /etc/passwd | cut -d ":" -f 5 | cut -d "," -f 1 | egrep '[а-Я]* [а-Я]{7,}$'
or: cut -d: -f5 /etc/passwd | cut -d ',' -f1 | egrep '.* .{7,}$'

# 03-a-5003
# Изведете имената на хората с второ име по-късо от 8 (<=7) символа според /etc/passwd // !(>7) = ?
cat /etc/passwd | cut -d ":" -f 5 | cut -d "," -f 1 | egrep '[а-Я]* [а-Я]{,7}$'
or: cut -d: -f5 /etc/passwd | cut -d ',' -f1 | egrep '.* .{,7}$'

# 03-a-5004
# Изведете целите редове от /etc/passwd за хората от 03-a-5003
egrep '.*:.*:.*:.*:[а-Я]* [а-Я]{,7},.*' /etc/passwd | wc -l

# 03-a-6000 v2022
# Копирайте <РЕПО>/exercises/data/emp.data във вашата home директория.
# Посредством awk, използвайки копирания файл за входнни данни, изведете:

# - общия брой редове
awk '{count+=1} END {print count}' file
or: awk '{print NR}' file | tail -n 1

# - третия ред
awk 'NR == 3 { print }' file

# - последното поле от всеки ред
awk '{ print $NF }' file

# - последното поле на последния ред
awk '{ last = $NF } END { print last }' file

# - всеки ред, който има повече от 4 полета
awk 'NF > 4 { print }' file

# - всеки ред, чието последно поле е по-голямо от 4
awk '$NF > 4 { print }' file

# - общия брой полета във всички редове
awk '{ count+=NF } END { print count }' file

# - броя редове, в които се среща низът Beth
awk '$0 ~ "Beth" { count+=1 } END { print count }' file

# - най-голямото трето поле и редът, който го съдържа
awk '$3 > max { max=$3; row=$0 } END { print max, "is in row: ", row }' file

# - всеки ред, който има поне едно поле
awk 'NF >= 1 { print }' file

# - всеки ред, който има повече от 17 знака
awk 'length($0) > 17 { print }' file

# - броя на полетата във всеки ред и самият ред
awk '{ print length($0), $0 }' file

# - първите две полета от всеки ред, с разменени места
awk '{ print $2, $1 }' file

# - всеки ред така, че първите две полета да са с разменени места
awk '{ print $2, $1, $3 }' file

# - всеки ред така, че на мястото на първото поле да има номер на реда
awk '{ print NR, $2, $3 }' file

# - всеки ред без второто поле
awk '{ print $1, $3 }' file

# - за всеки ред, сумата от второ и трето поле
awk '{ print $2 + $3 }' file

# - сумата на второ и трето поле от всеки ред
awk '{ sum+=$2 + $3 } END { print sum }' file


# 03-b-0300
# Намерете само Group ID-то си от файлa /etc/passwd.
grep "^s<fn>" /etc/passwd | cut -d: -f4

# 03-b-3000
# Запазете само потребителските имена от /etc/passwd във файл users във вашата home директория.
cut -d ":" -f 1 /etc/passwd >> users

# 03-b-3400
# Колко коментара има във файла /etc/services ? Коментарите се маркират със символа #, след който всеки символ на реда се счита за коментар.
egrep "^.*#.*$" /etc/services | wc -l

# 03-b-3500
# Колко файлове в /bin са 'shell script'-oве? (Колко файлове в дадена директория са ASCII text?)
file /bin/* | egrep 'shell script' | wc -l
# или:
find /bin -type f | xargs file | grep 'shell script' | wc -l

# 03-b-3600
# Направете списък с директориите на вашата файлова система, до които нямате достъп. Понеже файловата система може да е много голяма, търсете до 3 нива на дълбочина.
find / -maxdepth 3 -type d ! -readable 2> /dev/null

# 03-b-4000
# Създайте следната файлова йерархия в home директорията ви:
# dir5/file1
# dir5/file2
# dir5/file3
mkdir dir5
touch dir5/file{1,2,3}

# Посредством vi въведете следното съдържание:
# file1:
# 1
# 2
# 3

# file2:
# s
# a
# d
# f

# file3:
# 3
# 2
# 1
# 45
# 42
# 14
# 1
# 52

# Изведете на екрана:
#     * статистика за броя редове, думи и символи за всеки един файл
wc file1
wc file2
wc file3
#     * статистика за броя редове и символи за всички файлове
wc -ml file{1,2,3}
#     * общия брой редове на трите файла
cat dir5/file{1,2,3} | wc -l


# 03-b-4001 v2022
# Във file2 (inplace) подменете всички малки букви с главни.
sed -i 's/\(.*\)/\U\1/g' dir5/file2

# 03-b-4002
# Във file3 (inplace) изтрийте всички "1"-ци.
sed -i '/1/d' dir5/file3

# 03-b-4003
# Изведете статистика за най-често срещаните символи в трите файла.
sed 's/\(.\)/\1\n/g' dir5/file{1,2,3} | awk 'NF' | sort | uniq -c | sort
older: find dir5/file{1,2,3} | xargs -I % sh -c 'sed "s/./\0\n/g" % | sed "/^$/d" | sort | uniq -c | sort -n | tail -n 1'

# 03-b-4004
# Направете нов файл с име по ваш избор, който е конкатенация от file{1,2,3}.
cat dir5/file{1,2,3} > file

# 03-b-4005
# Прочетете текстов файл file1 и направете всички главни букви малки като запишете резултата във file2.
sed 's/\(.\)/\L\1/g' dir5/file2 >> dir5/file1

# 03-b-5200
# Изтрийте всички срещания на буквата 'a' (lower case) в /etc/passwd и намерете броят на оставащите символи.
tr -d a < /etc/passwd | wc -m

# 03-b-5200 v2022
# Намерете броя на символите, различни от буквата 'а' във файла /etc/passwd
sed 's/\([^a]\)/\1\n/g' /etc/passwd | awk 'NF' | wc -l

# 03-b-5300
# Намерете броя на уникалните символи, използвани в имената на потребителите от /etc/passwd.
sed 's/\(.\)/\1\n/g' /etc/passwd | awk 'NF' | sort | uniq | wc -l

# 03-b-5400
# Отпечатайте всички редове на файла /etc/passwd, които не съдържат символния низ 'ov'.
grep -v 'ov' /etc/passwd

# 03-b-6100
# Отпечатайте последната цифра на UID на всички редове между 28-ми и 46-ред в /etc/passwd.
head -n 46 /etc/passwd  | tail -n 19 | cut -d: -f3 | egrep -o '[0-9]$'

# 03-b-6700
# Отпечатайте правата (permissions) и имената на всички файлове, до които имате read достъп, намиращи се в директорията /tmp. (hint: 'man find', вижте -readable)
find /tmp -type f -readable -exec ls -l {} \; 2> /dev/null | cut -d" " -f1,9

# 03-b-6900
# Намерете имената на 10-те файла във вашата home директория, чието съдържание е редактирано най-скоро. На първо място трябва да бъде най-скоро редактираният файл. Намерете 10-те най-скоро достъпени файлове. (hint: Unix time)
ls -tl | head -n 10
ls -ltu | head -n 10
# -t sorts by time, newest first
other solutions:
find . -type f -exec stat --format="%Y %n" {} \; | sort -rn -k1 | head -n 10 | cut -d" " -f2
find . -type f -exec stat --format="%X %n" {} \; | sort -rn -k1 | head -n 10 | cut -d" " -f2

# 03-b-7000
# Файловете, които съдържат C код, завършват на `.c`.
# Колко на брой са те във файловата система (или в избрана директория)?
find . -type f -name "^*.c$" | wc -l
# Колко реда C код има в тези файлове?
find . -type f -name "^*.c$" | xargs -I % sh -c 'wc -m %'

# 03-b-7000 v2022
# да приемем, че файловете, които съдържат C код, завършват на `.c` или `.h`.
# Колко на брой са те в директорията `/usr/include`?
find /usr/include/ -type f -regextype posix-extended -regex ".*\.(c|h)$" | wc -l
# Колко реда C код има в тези файлове?
find /usr/include/ -type f -regextype posix-extended -regex ".*\.(c|h)$" | xargs -I % sh -c 'wc -m %'
общо редове за всички файлове:
find /usr/include/ -type f -regextype posix-extended -regex ".*\.(c|h)$" | xargs -I % sh -c 'cat %' | wc -m

# 03-b-7500
# Даден ви е ASCII текстов файл (например /etc/services). Отпечатайте хистограма на N-те (например 10) най-често срещани думи.
cat /etc/services | sed 's/\([[:space:]]\)/\n/g' | sed '/^$/d' | sort | uniq -c | sort -nr | head -n 10

# 03-b-8000
# Вземете факултетните номера на студентите от СИ и ги запишете във файл si.txt сортирани.
egrep -o '^s[[:digit:]]{5}' /etc/passwd | tr -d 's' | sort -n > si.txt

# 03-b-8520s
# Изпишете всички usernames от /etc/passwd с главни букви.
cut -d : -f 1 /etc/passwd | sed 's/\(.\)/\U\1/g'

# 03-b-8600
# Shell Script-овете са файлове, които по конвенция имат разширение .sh. Всеки такъв файл започва с "#!<interpreter>" , където <interpreter> указва на операционната система какъв интерпретатор да пусне (пр: "#!/bin/bash", "#!/usr/bin/python3 -u").
# Намерете всички .sh файлове и проверете кой е най-често използваният интерпретатор.
find / -name "*.sh" 2> /dev/null -type f | xargs -I % sh -c 'cat % | head -n 1' | sort | uniq -c | sort -n | tail -n 1

# 03-b-8700
# Намерете 5-те най-големи групи подредени по броя на потребителите в тях.
cut -d : -f 4 /etc/passwd | sort -n | uniq -c | sort -n | tail -n 5

# 03-b-9000
# Направете файл eternity. Намерете всички файлове, които са били модифицирани в последните 15мин (по възможност изключете .).  Запишете във eternity името на файла и часa на последната промяна.
find / -type f -mtime -15 ! -name "." -exec ls -l {} \; 2> /dev/null | cut -d ' ' -f 6,7,8,9 > eternity

# 03-b-9050
# Копирайте файл /home/tony/population.csv във вашата home директория.
cp /srv/os/fmi-os/exercises/data/population.csv .

# 03-b-9051
# Използвайки файл population.csv, намерете колко е общото население на света през 2008 година. А през 2016?
grep ".*,.*,2008.*" population.csv | cut -d , -f 4 | awk 'BEGIN {count=0} {count+=$1} END {print count}'
grep ".*,.*,2016.*" population.csv | cut -d , -f 4 | awk 'BEGIN {count=0} {count+=$1} END {print count}'

# 03-b-9052
# Използвайки файл population.csv, намерете през коя година в България има най-много население.
grep 'Bulgaria' population.csv | sort -n -t , -k 4 | tail -n 1 | cut -d , -f 3

# 03-b-9053
# Използвайки файл population.csv, намерете коя държава има най-много население през 2016. А коя е с най-малко население?
# (Hint: Погледнете имената на държавите)
grep '.*,.*,2016.*' population.csv | sort -n -t , -k 4 | tail -n 1 | cut -d , -f 1,2

# 03-b-9054
# Използвайки файл population.csv, намерете коя държава е на 42-ро място по население през 1969. Колко е населението й през тази година?
grep '.*,.*,1969.*' population.csv | sort -n -t , -k 4 | tail -n 43 | head -n 1 | cut -d , -f 1
grep '.*,.*,1969.*' population.csv | sort -n -t , -k 4 | tail -n 43 | head -n 1 | cut -d , -f 1 | xargs -I % sh -c 'egrep '%,.*,2016.*' population.csv' | cut -d , -f 4

# 03-b-9100
# В home директорията си изпълнете командата `curl -o songs.tar.gz "http://fangorn.uni-sofia.bg/misc/songs.tar.gz"`

# 03-b-9101
# Да се разархивира архивът songs.tar.gz в папка songs във вашата home директорията.
tar -xzf songs.tar.gz -C ./songs

# 03-b-9102
# Да се изведат само имената на песните.
ls songs/ | cut -d - -f 2 | cut -d '(' -f 1 | sed 's/^ \(.*\)/\1/g'

# 03-b-9103
# Имената на песните да се направят с малки букви, да се заменят спейсовете с долни черти и да се сортират.
ls songs/ | cut -d - -f 2 | cut -d '(' -f 1 | sed 's/^ \(.*\)/\1/g' | sed 's/\(.\)/\L\1/g' | sed '/^$/d'| tr ' ' '_' | sort

# 03-b-9104
# Да се изведат всички албуми, сортирани по година.
ls songs/ | cut -d - -f 2 | cut -d '(' -f 2 | sed 's/\(.*\)).ogg/\1/g' | sort -n -t , -k 2

# 03-b-9105
# Да се преброят/изведат само песните на Beatles и Pink.
ls songs/ | grep '[Beatles|Pink] -.*' | wc -l

# 03-b-9106
# Да се направят директории с имената на уникалните групи. За улеснение, имената от две думи да се напишат слято:
# Beatles, PinkFloyd, Madness
ls songs/ | cut -d - -f 1 | tr -d ' ' | sort -u | xargs -I % sh -c 'mkdir %'

# 03-b-9200
# Напишете серия от команди, които извеждат детайли за файловете и директориите в текущата директория, които имат същите права за достъп както най-големият файл в /etc директорията.
# Най-голям файл: 
find /etc/ -type f -exec wc -c {} \; 2> /dev/null | sort -n -k 1 | tail -n 1 | cut -d ' ' -f 2
# File permissions:  
ls -l $(find /etc/ -type f -exec wc -c {} \; 2> /dev/null | sort -n -k 1 | tail -n 1 | cut -d ' ' -f 2) | cut -d ' ' -f 1
# and final:
find . -type f -exec ls -l {} \; | egrep "$(ls -l $(find /etc/ -type f -exec wc -c {} \; 2> /dev/null | sort -n -k 1 | tail -n 1 | cut -d ' ' -f 2) | cut -d ' ' -f 1).*"

# 03-b-9300
# Дадени са ви 2 списъка с email адреси - първият има 12 валидни адреса, а вторията има само невалидни. Филтрирайте всички адреси, така че да останат само валидните. Колко кратък регулярен израз можете да направите за целта?
# Валидни email адреси (12 на брой):
# email@example.com
# firstname.lastname@example.com
# email@subdomain.example.com
# email@123.123.123.123
# 1234567890@example.com
# email@example-one.com
# _______@example.com
# email@example.name
# email@example.museum
# email@example.co.jp
# firstname-lastname@example.com
# unusually.long.long.name@example.com

# Невалидни email адреси:
# #@%^%#$@#$@#.com
# @example.com
# myemail
# Joe Smith <email@example.com>
# email.example.com
# email@example@example.com
# .email@example.com
# email.@example.com
# email..email@example.com
# email@-example.com
# email@example..com
# Abc..123@example.com
# (),:;<>[\]@example.com
# just"not"right@example.com
# this\ is"really"not\allowed@example.com

^([a-zA-Z-_0-9]\.?){1,}[^.]@[a-zA-Z0-9]{1,}-?[a-zA-Z0-9]*\.([[:word:]]\.?){1,}
