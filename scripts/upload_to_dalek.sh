if [ ! "$1" ]
then
	echo "You can upload one of the below folders:"
	echo "Air4641SW_2013-01-18_11.33  bin  books  docs  downloads  measurements  mine  misc patches  research  scripts  selections"
	echo "scp -r \$1 nejatonay.erkose@dalek:/home/nejatonay.erkose/\$2"
else
	scp -r $1 nejatonay.erkose@dalek:/home/nejatonay.erkose/$2
fi
