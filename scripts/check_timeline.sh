#!/bin/bash 
#by Nejat Onay Erköse

prep_files(){

	filename="$2_snd_`date +%F_%H`.txt"
	cp $1 sentMFCG/$1
	cd sentMFCG/
	cat *.txt > all.txt
	rm $filename 2>> /dev/null
	rm duplicates.txt 2>> /dev/null
	sort all.txt | uniq -d > duplicates.txt
	num_dup=`wc -l duplicates.txt | cut -d " " -f1`
	echo "Number of duplicates: $num_dup"
}

prune_it(){

	echo "Pruning Duplicates from older productions..."

	i=0
	while read LINE
	do
        	while read LINE2
	        do
        	        if [ "$LINE" = "$LINE2" ]
                	then
		                     continue
                	else
	                     echo "$LINE" >> $filename
			     #echo $LINE
                	    (( i++ ))
	                fi
        	done < duplicates.txt
	done < $1

	if [ $num_dup -eq 0 ]
	then
        	cp $1 $filename
        	#i=`wc -l $filename | cut -d " " -f1`
	        i=$2
	else
                ((i = $2 - $i ))
        fi

	rm duplicates.txt >> /dev/null
	rm all.txt
	rm $1 2>> /dev/null
	rm ../*.txt

	echo "Done duplicate prunning on the old records..."
	echo "Number of duplicate free records are $i and they are stored in file: $filename"
        filestore="$2_rec_`date +%F_%H`.txt"

	sed '/^WPS.*/d' $filename > $filestore
	mv $filename ../
	echo " "
}

prep_files $1 $2
prune_it $1 $2

