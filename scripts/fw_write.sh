#!/bin/bash
release="$2"
interface="eth1"

#device=${0##*_}
#echo "${device}"
#device_family=${device:0:7}
#echo "${device_family}"


if [ -x "./fwrecover/fwrecover-latest/fwrecover" ]
then
	fwrecover_ver="./fwrecover/fwrecover-latest/fwrecover"
	echo "exists"
else
	# if [ "$1" == "qtn" ]
	# then
	    # fwrecover_ver="fwrecover-2.0"
	# else
	    fwrecover_ver="fwrecover-2.1"
	# fi
fi

echo "${fwrecover_ver}"

if [ $1 ]
then
    interface="$1"
fi

$fwrecover_ver -d $interface -f $release
$fwrecover_ver -d $interface -s f_image_num 0 && \
$fwrecover_ver -d $interface -s boot_flag 'success' && \
$fwrecover_ver -d $interface -e
$fwrecover_ver -d $interface -b
