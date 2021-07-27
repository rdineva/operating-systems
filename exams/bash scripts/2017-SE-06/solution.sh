#!/bin/bash

if [ $(whoami) != "s<fn>" ]; then
    echo "ERROR: you must be root"
    exit 1
fi

ps aux | tail -n +2 | awk '{print $1}'| grep -v root | sort -u | while read user; do
    user_homedir=$(eval echo ~$user)
    has_homedir=$(ls -dl $user_homedir 2> /dev/null && echo "true" || echo "false")

    owner=$(ls -dl $user_homedir | awk '{print $3}')
    is_owner=$([ $owner == $user ] && echo "true" || echo "false")

    write_perm=$(ls -dl $user_homedir | awk '{print $1}' | grep '^..-')

    if [[ $has_homedir == "false" ]] || [[ $is_owner == "false" ]] || [[ ! $write_perm ]]; then
        ps -u $user --no-headers
    fi

    user_rss=$(ps -o rss --no-headers -u $user | awk 'BEGIN {sum=0} {for(i=1; i<=NF; i++) {sum+=$i}} END{print sum}')
    root_rss=$(ps -o rss --no-headers -u root | awk 'BEGIN {sum=0} {for(i=1; i<=NF; i++) {sum+=$i}} END{print sum}')

    if [ $user_rss -gt $root_rss ]; then
        echo "er $user RSS is reater than root. Killing all $user processes..."
        killall -u $user
    fi
done
