if [ "$1" = "noe" ]
then
	echo "Connecting to oldbook at home"
	ssh $1@192.168.2.20

elif [ "$1" = "noe287" ]
then
	echo "Connecting to office desktop"
	ssh $1@10.20.0.114

elif [ "$1" = "noe-vm" ]
then	
	echo "Connecting to airbook at home"
	ssh $1@192.168.2.194
else
	echo "No such user"

fi

