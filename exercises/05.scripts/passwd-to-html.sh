#!/bin/bash

# 05-b-5500

# Да се напише shell script, който генерира HTML таблица съдържаща описание на потребителите във виртуалката ви. Таблицата трябва да има:
# - заглавен ред с имената нa колоните
# - колони за username, group, login shell, GECKO field (man 5 passwd)

# Пример:
# $ ./passwd-to-html.sh > table.html
# $ cat table.html
# <table>
#   <tr>
# 	<th>Username</th>
# 	<th>group</th>
# 	<th>login shell</th>
# 	<th>GECKO</th>
#   </tr>
#   <tr>
# 	<td>root</td>
# 	<td>root</td>
# 	<td>/bin/bash</td>
# 	<td>GECKO here</td>
#   </tr>
#   <tr>
# 	<td>ubuntu</td>
# 	<td>ubuntu</td>
# 	<td>/bin/dash</td>
# 	<td>GECKO 2</td>
#   </tr>
# </table>

if [ ! $# -eq 0 ]; then
    echo "ERROR: no params needed"
    exit 1
fi

cat /etc/passwd | while read line; do
    username=$(echo $line | cut -d : -f1)
    group_id=$(echo $line | cut -d : -f4)
    group=$(getent group $group_id | cut -d : -f1)
    shell=$(echo $line | cut -d : -f7)
    echo "<tr>"
    echo -e "\t<th>$username</th>"
    echo -e "\t<th>$group</th>"
    echo -e "\t<th>$shell</th>"
    echo "</tr>"
done
