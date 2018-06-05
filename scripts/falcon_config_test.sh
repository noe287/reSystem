#!/bin/bash

FILE="ssid_pass.txt"

for i in {1..50}
do
SSID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 30 | head -n 1)
PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)

echo "***************************************************$i****************************************************************" >> $FILE
echo "*******************************************************************************************************************" >> $FILE
echo " " >> $FILE
echo $i
echo " " >> $FILE

(echo "aci-cli aci_wifi_set_sta_ssid 0 $SSID";sleep 1; ) | nc 192.168.1.1 6000
sleep 3
(echo "aci-cli aci_wifi_set_sta_wpa_password 0 $PASS";sleep 1;) | nc 192.168.1.1 6000
sleep 3
(echo "aci-cli aci_wifi_command_apply 0";sleep 2) | nc 192.168.1.1 6000

#ssid1=`(echo "aci-cli aci_wifi_get_sta_ssid 0"; sleep 2;) | nc 192.168.1.1 6000` # >> $FILE #|sed -ne 's/^.*;1m\(.*\)^.*/\1/p' >> $FILE
sleep 5
pass1=`(echo "aci-cli aci_wifi_get_sta_wpa_password 0"; sleep 1;) | nc 192.168.1.1 6000` #>> $FILE #| sed -ne 's/^.*;1m\(.*\)^.*/\1/p' >> $FILE
sleep 5
iwconf=`(echo "iwconfig"; sleep 1) | nc 192.168.1.1 6000 | grep wl0.1 |  sed -ne 's/^.*ESSID:"\(.*\).*"/\1/p'`


echo "SET  		 		    	:   		iwconfig" >> $FILE
echo "SSID_S: $SSID SSID_W: $iwconf PASS_S $PASS: PASS_G: $pass1" >> $FILE

sleep 1
done


