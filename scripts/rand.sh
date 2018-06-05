#!/bin/bash
# rand.sh: random UUID and TRUSTED PIN generator, by Firat :)
do_rand() {
    for D in `seq 1 $1`; do echo -n $(( ${RANDOM} % 10 )); done; echo
}


#echo -n "WPS_TRUSTED_PIN             WPS_CONFIG_UUID" > trustedPin-ConfigUUID.txt
#echo " " >> trustedPin-ConfigUUID.txt

for i in `seq 1 $1`
do
r16=`do_rand 16`
r24=`do_rand 24`
r8=`do_rand 8`
rNum=`do_rand $2`

done

ar=($(cat "/home/noe287/MY_DEVEL/etc/conf/make_pre_config.conf"))
 
rm "/home/noei287/MY_DEVEL/etc/conf/make_pre_config.conf"

#ar=("${ar[@]}" "$r24" "$r16")

ar[1]="$r8"
ar[4]="$r24"
ar[5]="$r16"

for i in `seq 0 $((${#ar[@]} - 1 ))`
do 
 echo ${ar[$i]} >> "/home/noe287/MY_DEVEL/etc/conf/make_pre_config.conf"
done

cat "/home/noe287/MY_DEVEL/etc/conf/make_pre_config.conf"
echo "######################## random number generated ######################"
echo $rNum 
