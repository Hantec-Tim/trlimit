#!/bin/bash

addString() {
	if [ $(checkForSpaces "$1") != 0 ]
	then
		return 1
	fi
	if [ ! -f "$2" ]
	then
		printf "File does not exist\n"
		return 1
	fi
	if [ $(hasString $1 $2) = 0 ]
	then
		printf "$1 " >> "$2"
		return 0
	else
		printf "String already in list\n"
		return 1
	fi
	
}
checkForSpaces() {
	case "$1" in *\ *) 
			echo 1
			return 0
	          ;;
	       *) echo 0 
	       	return 0
	           ;;
	esac

}
removeString() {
	if [ $(checkForSpaces "$1") != 0 ]
	then
		return 1
	fi
	if [ ! -f "$2" ]
	then
		printf "File does not exist\n"
		return 1
	fi
	result=$(sed 's/ '$1'\ / /g' $2)
	echo "$result" > "$2"
}
hasString() {
	if [ $(checkForSpaces "$1") != 0 ]
	then
		return 1
	fi
	if [ ! -f "$2" ]
	then
		printf "File does not exist\n"
		return 1
	fi
	file=$(cat "$2")
	for nick in $file
	do
		if [ "$nick" = "$1" ]
		then
			echo 1
			return 0
		fi
	done
	echo 0
	return 0
}

createFile() {
	local fullpath="$1"
	if [ -f "$fullpath" ]
	then
		rm "$fullpath"
	fi
	touch "$fullpath"
}

createFile testList
addString asdf testList
addString asdf testList
hasString asdf testList
addString awfdawd testList
addString awfdawdafd testList
addString awfdawawerfsaegd testList
removeString asdf testList