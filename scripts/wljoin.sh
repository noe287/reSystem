if [ "$1" = "0" ]
then
	sudo killall wpa_supplicant
	exit
fi

sudo killall wpa_supplicant
sudo ifconfig wlan0 up
sudo ifconfig wlan1 up
sudo wpa_supplicant -Dwext -iwlan$2 -c $SCRIPTS_DIR/wlconf/$1.conf -dddd &



