#!/bin/bash
LOGS=$HOME/minicomlogs

if [ "$1" = "-s" ] 
then
    ls /dev/*USB* | grep USB
    exit 0
fi

if [ ! -d  $LOGS ]
then
	mkdir -p $LOGS
fi

if [ $1 ]
then
   option="-D /dev/ttyUSB$1 -C $LOGS/$(date +%F_%H:%M) -c on"
   if [ $2 ]
   then
     option="-D /dev/ttyUSB$1 -C $LOGS/$2"_"$(date +%F_%H:%M) -c on"
   fi
else
    a=`ls /dev/ | grep ttyUSB`
    option="-D /dev/$a -C /tmp/$(date +%F_%H:%M) -c on"

fi


  #minicom -D /dev/ttyUSB$1 -C /tmp/$(date +%F:%M) -c on
sudo minicom $option
