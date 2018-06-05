#!/bin/bash

if [ $1 ]
then
   option="-D /dev/ttyUSB$1 -C /tmp/$(date +%F_%H:%M) -c on"
   if [ $2 ]
   then
     option="-D /dev/ttyUSB$1 -C /tmp/$2"_"$(date +%F_%H:%M) -c on"
   fi
else
    a=`ls /dev/ | grep ttyUSB`
    option="-D /dev/$a -C /tmp/$(date +%F_%H:%M) -c on"

fi

if [ "$1" = "-s" ] 
then
    ls /dev/*USB* | grep USB
    exit 0
fi

  #minicom -D /dev/ttyUSB$1 -C /tmp/$(date +%F:%M) -c on
sudo minicom $option
