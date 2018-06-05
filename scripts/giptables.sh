

if [ ! $1 ]
then
	echo "usage: giptables [1,2] 1 for gufw : 2 for firestarter"
elif [ $1 = 1 ]
then
	sudo gufw &
elif [ $1 = 2 ]
then
	sudo firestarter &
else
	echo "wrong option entered."
fi
