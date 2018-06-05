if [ $1 ]
then
	sudo nmap -v -sn 192.168.$1.* | grep -C2 up
else
	sudo nmap -v -sn 192.168.1.* | grep -C2 up
	sudo nmap -v -sn 192.168.2.* | grep -C2 up
fi
