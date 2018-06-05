#!/bin/bash

BACKUP_DIR="/home/noe287/BACKUPS"

dir=`pwd`
dirname=`basename $dir`

#if [ $2 ] 
#then
#   targetdir=$2
#else
#   targetdir=$dir
#fi

target_dir=$BACKUP_DIR

if [ $1 ]
then
	tarname=$1"_"`date +%Y%m%d`.tgz
	echo "$tarname $targetdir ###########################################################################################"
	tar -zcvf $tarname .
	echo  "tar -zcvf $tarname ."
else
	tarname=$dirname"_"`date +%Y%m%d`.tgz
	tar -zcvf $tarname .
	echo  "tar -zcvf $tarname ."
fi

echo " "

if [ $tarname ]
then
	read -p "Want to upload to Dalek Server: " YESNO
	if [ "$YESNO" = "y" -o $YESNO = "Y" ];then
		echo "File is being uploaded to Dalek server:"
		upload_to_dalek.sh $tarname 
	fi
fi

mv $tarname $target_dir
