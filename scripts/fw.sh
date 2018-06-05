#!/bin/bash                                                                                                                                                                                                                                                                     
release="$2"
interface="enp6s0"

#device=${0##*_}
#echo "${device}"
#device_family=${device:0:7}
#echo "${device_family}"

if [ "$1" == "qtn" ]
then
    fwrecover_ver="fwrecover-2.0"
else
    fwrecover_ver="fwrecover-2.1"
fi

echo "${fwrecover_ver}"

if [ $3 ]
then
    interface="$3"
fi

$fwrecover_ver -d $interface -f $release
$fwrecover_ver -d $interface -s f_image_num 0 && \
$fwrecover_ver -d $interface -s boot_flag 'success' && \
$fwrecover_ver -d $interface -e
$fwrecover_ver -d $interface -b
