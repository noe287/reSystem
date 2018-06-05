#!/bin/bash 

#by Nejat Onay Erköse

#filename="wps_pin_configUUid_no_dup_`date +%F_%H`.txt"

prep_files(){

	filename="$2_rec_nodup.txt"

	rm $filename 2>> /dev/null

	rm duplicates.txt 2>> /dev/null

	sort $1 | uniq -d > duplicates.txt

	num_dup=`wc -l duplicates.txt| cut -d " " -f1`
	echo "Number of duplicates: $num_dup"

}

prune_it(){
	echo "Pruning duplicates..."

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
                    		(( i++ ))
	                fi
        	done < duplicates.txt
	done < $1

	if [ $num_dup -eq 0 ]
	then
        	cp $1 $filename
	        i=$2
        	rm $1 2>>/dev/null
	else
		((i = $2 - $i ))
	fi

	rm duplicates.txt 2>> /dev/null
	echo "Done duplicate prunning within the file..."
	#echo "Number of duplicate free records are $i and they are stored in file: $filename"
	echo " "
}

prep_files $1 $2
prune_it $1 $2

#check the other duplicate entries from older productions
echo "Checking for duplicates within the old records"
./check_timeline.sh $filename $2 
