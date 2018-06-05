#!/bin/bash

cd $1 #dir with all
for D in `ls`
do
        echo " ========================$D================================="
        if [ -d $D ]
	then
		pkgname $D
        	cd $D #dirs with tags or devel
	else
		continue
	fi
#       for A in `ls`
#       do
#               svn info $A | grep URL  | cut -d " " -f2
#               grep -rn "LICENSE" $A | head -n1
#       done
          findURL
        cd ..

        for A in `ls`
        do
                grep -rnh "MODULE_LICENSE" $A | head -n5
                grep -rnh "Copyright" $A | head -n5
                grep -rnh "GNU" $A | head -n3
        done
done
