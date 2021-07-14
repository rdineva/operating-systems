#!/bin/bash

if [ ! $# -eq 1 ]; then
	echo "ERROR: 1 argument needed"
	exit 1
fi

if [ ! -f $1 ]; then
	echo "ERROR: $1 is not a file"
	exit 2
fi

cat $1 | grep -v "^#" | while read url; do
	content=$(curl $url | sed -n '/<body>/,/<\/body>/p')
	date=""
	category=""
	echo "$content" | while read line; do
		if [ $(echo $line | egrep '<tr class="Title2 TI21">' | wc -l) -eq 1 ]; then
			date=$(echo $line | egrep '<tr class="Title2 TI21">' | egrep -o "[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{4}")
			day=$(echo $date | cut -d . -f1)
			if [ $(echo -n $day | wc -m) -eq 1 ]; then
				day=$(echo "0$day")
			fi
			month=$(echo $date | cut -d . -f2)
			if [ $(echo -n $month | wc -m) -eq 1 ]; then
				month=$(echo "0$month")
			fi
			year=$(echo $date | cut -d . -f3)

			date=$(echo "$day.$month.$year")
			continue
		fi
		
		if [ $(echo $line | egrep '<tr class="Head1.*</tr>' | wc -l) -eq 1 ]; then 
			category=$(echo $line | egrep '<tr class="Head1.*</tr>' | sed "s/.*<a name=\"\(.*\)\".*/\1/g")
			continue
		fi
				
		if [ $(echo $line | egrep '<tr class="ResLine.*</tr>' | wc -l) -eq 1 ]; then
			person=$(echo $line | egrep '<tr class="ResLine.*</tr>' | sed 's/\([^<td]*\)</\1\n/g' | cut -d '>' -f2)
			platz=$(echo $person | cut -d ' ' -f1)
			if [ $(echo $platz | grep "\.$" | wc -l) -eq 1 ]; then
				platz=$(echo $platz | sed 's/\(.*\)./\1/g')
			fi
	
			name=$(echo $person | rev | cut -d ' ' -f7- | rev | cut -d ' ' -f2-)
		
			if [ $(echo $name | egrep ".*,.*" | wc -l) -eq 1 ]; then
				name=$(echo $name | sed 's/\([a-zA-Z]*\), \([a-zA-Z ]*\)/\2 \1/g')
			fi
		
			clb=$(echo $person | rev | cut -d ' ' -f6 | rev)		
			call=$(echo $person | rev | cut -d ' ' -f5 | rev)
			if [ $call = "&nbsp;" ]; then
				call=""
			fi
			
			laufzeit=$(echo $person | rev| cut -d ' ' -f4 | rev)
			fox=$(echo $person | rev| cut -d ' ' -f3 | rev)
			stNr=$(echo $person | rev | cut -d ' ' -f2 |rev)
			echo "$date:$category:$platz:$name:$clb:$call:$laufzeit:$fox:$stNr"
		fi
	done
done
