#!/bin/sh

if [ $# -ne 3 ]; then
	 echo 1>&2 "This script replaces strings in text files"
         echo 1>&2 Usage: $0 "<PATH> <REAPLACE_THIS> <WITH_THIS>"
         exit 1
fi

perl -p -i -e "s/$2/$3/gi" ./*
perl -p -i -e "s/$2/$3/gi" $1/*.*

#function my_replace(){
#grep -lr -e '"$1"' * | xargs sed -i 's/"$1"/"$2"/g'
#}

