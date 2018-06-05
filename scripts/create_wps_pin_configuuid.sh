#!/bin/bash    
# by Nejat Onay Erköse - Wireless Team

if [ ! $1 ]
then
	echo "[Usage: ./create_wps_pin_configuuid.sh 50000]"
	echo "Creates 50K of unique wpsPin-ConfigUUID pairs"
	exit
fi




do_rand() {

    for D in `seq 1 $1`; do echo -n $(( ${RANDOM} % 10 )); done; echo

}

check_duplicates(){

	echo "Checking for duplicates within the file itself"
	./check_dup_cp.sh $filename $1

	#echo "Checking for duplicates within the old records"
	#./check_timeline.sh $filenamenodup $1

}

main(){
	
	filename="$1_raw_`date +%F_%H`.txt"
	
	if [ ! -d "sentMFCG" ]
	then
		mkdir sentMFCG
	fi

	echo "Creating $1 ConfigUUID-WPS_PIN pairs"

	echo -n "WPS_TRUSTED_PIN             WPS_CONFIG_UUID" > $filename

	echo " " >> $filename

	for i in `seq 1 $1`
	do
		r16=`do_rand 16`
		r24=`do_rand 24`

		echo -n $r16"        "$r24 >> $filename
		echo " " >> $filename
	done

	filenamenodup="wpspin-configuuid_nodup_$1.txt"

	check_duplicates $1   

}

main $1




