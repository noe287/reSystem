#!/bin/bash

# What more parameters are needed to be placed in pack_list?
# What to do with TAG metadata?
# What to take from base metadata and others?
# Concluded license'ı FOSS yazmayıp yinede freeware olanlar ne olmalı?


filename=$BSPPATH"/foss_packet_list.txt"
config=$BSPPATH"/.config"
revlist=$BSPPATH"/release/revision"                   #application that creates fw packages list
metadata1=$BSPPATH"/"$2"/metadata"                      #buildsys/packagename/metadata
metadata2=$BSPPATH"/"$2"/"$1"/metadata"                 #buildsys/packagename/branchname/metadata

fw_pack_list=$BSPPATH"/fw_packet_list.txt"

function parse_dir_metadata(){

    while read LINE;do
	echo $LINE | grep PACKAGE_NAME >> $filename
	#echo $LINE | grep VERSION  >> ../$filename
	#echo $LINE | grep CONCLUDED_LICENSE >>../$filename
	#echo $LINE | grep LICENSE_TYPE >> ../$filename
	#echo $LINE | grep IS_MODIFIED >> ../$filename
	#echo $LINE | grep COPYRIGHT >> ../$filename
    done < $metadata1  #buildsys level metadata

}

function make_foss(){

	#if [ $1 ]
	#then
	#	config="configs/$1.config"
	#else
	#	config=".config"
	#fi

	$revlist $BSPROOT $config | tee a.txt
	count=`wc -l a.txt | cut -d " " -f1`
	cat a.txt | head -n $(expr $count - 3) | cut -d " " -f3 > $fw_pack_list
	rm a.txt
}


function main(){

k=0
	echo " " >> $filename
	echo " 		FOSS Packet Information List" >> $filename

while read BSYS_DIR; do
	
	metadata1=$BSPPATH"/"$BSYS_DIR"/metadata"
	cd $BSYS_DIR
	for i in  `ls`
	do
	   BRANCH_DIR=`file $i | grep directory | cut -d ":" -f1`
	   if [[ "$BRANCH_DIR" = "configs" || "$BRANCH_DIR" = "" ]]
	   then
		continue
	   else
		TYPE=`cat $metadata1 | grep LICENSE_TYPE | cut -d "=" -f2 | tr -d ' ' `
		#echo $BSYS_DIR":"$TYPE
		if [ "$TYPE" = "FOSS" ]
		then
			echo " "  >> $filename
			echo "################" >>$filename
			echo "Package No: $k #" >>$filename
			echo "####################################################" >>$filename
			parse_dir_metadata $BRANCH_DIR
			k=$(( $k + 1 ))
		fi
	   fi
	done
	cd ..
done < $fw_pack_list

}

rm $filename

make_foss
main





