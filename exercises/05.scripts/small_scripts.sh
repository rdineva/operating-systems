#!/bin/bash

# 05-a-2000
# Сменете вашия prompt с нещо по желание. После върнете оригиналния обратно.
PS1="$(hostname) $"

# 05-a-2100
# Редактирайте вашия .bash_profile файл, за да ви поздравява (или да изпълнява някаква команда по ваш избор) всеки път, когато влезете в системата.
touch .bash_profile
vi .bash_profile
. .bash_profile

# 05-a-2200
# Направете си ваш псевдоним (alias) на полезна команда.
alias l="ls -la"

# 05-b-2000
# Да се напише shell скрипт, който приканва потребителя да въведе низ (име) и изпечатва "Hello, низ".
echo “Hello, $1”

# 05-b-2800
# Да се напише shell скрипт, който приема точно един параметър и проверява дали подаденият му параметър се състои само от букви и цифри.
if [ $# -lt 1 ]; then
    echo "Not enough params provided!"
    elif [ $# -gt 1 ]; then
    echo "Too many params!"
else
    [[ $1 =~ ^[0-9A-Za-z]*$ ]] && echo "true" || echo "false"
fi

# 05-b-3100
# Да се напише shell скрипт, който приканва потребителя да въведе низ - потребителско име на потребител от системата - след което извежда на стандартния изход колко активни сесии има потребителят в момента.
echo $(w | grep "$1.*" | wc -l)

# 05-b-3200
# Да се напише shell скрипт, който приканва потребителя да въведе пълното име на директория и извежда на стандартния изход подходящо съобщение за броя на всички файлове и всички директории в нея.
dirs=$(find $1 -type d | wc -l)
files=$(find $1 -type f | wc -l)
echo -e "dirs:files\n$dirs:$files"

# 05-b-3300
# Да се напише shell скрипт, който чете от стандартния вход имената на 3 файла, обединява редовете на първите два (man paste), подрежда ги по азбучен ред и резултата записва в третия файл.
paste -s $1 $2 | sort > $3

# 05-b-3400
# Да се напише shell скрипт, който чете от стандартния вход име на файл и символен низ, проверява дали низа се съдържа във файла и извежда на стандартния изход кода на завършване на командата с която сте проверили наличието на низа.
# NB! Символният низ може да съдържа интервал (' ') в себе си.
result=$(grep ".*$1.*" $2)
echo $?
[[ $(echo -e $result | wc -l) -gt 0 ]] && echo "true" || echo "false"
