if1="enp5s0"
if2="enp6s0"
wlif="wl01"

if [ ! $1 ]
then
	echo "1: $if2, 2: $if1, 3:both, 4: 0.0.0.0 all"
	exit
fi

if [ "$1" = "1" ]
then
	sudo ifconfig $if2 down
	sudo ifconfig $if2 up
	sudo ifconfig $if2 192.168.2.77
	sudo ifconfig $if2:0 192.168.1.77

elif [ "$1" = "2" ]
then
	sudo ifconfig $if1 down
	sudo ifconfig $if1 up
	sudo dhclient $if1

elif [ "$1" = "3" ]
then
	sudo ifconfig $if2 down
	sudo ifconfig $if2 up
	sudo ifconfig $if2 192.168.2.77
	sudo ifconfig $if2:0 192.168.1.77
	
	sudo ifconfig $if1 down
	sudo ifconfig $if1 up
	sudo dhclient $if1

        # rf_enable.sh $wlif #for wireless card

elif [ "$1" = "4" ]
then
	sudo ifconfig $if2 down
	sudo ifconfig $if2 up
	sudo ifconfig $if2 0.0.0.0
	sudo ifconfig $if2:0 0.0.0.0
	
	
	sudo ifconfig $if1 down
	sudo ifconfig $if1 up
	sudo ifconfig $if1 0.0.0.0
elif [ "$1" = "5" ]
then
   # rf_enable.sh #for wireless card
    sudo rfkill unblock wifi
    sudo rfkill unblock all
    sudo rfkill list
    sudo ifconfig $wlif up
    sudo lshw -class network   
fi
ifconfig
