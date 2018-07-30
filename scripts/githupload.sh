if [ ! $1 ]
then
	echo "usage: githupload c[b] conf.file[bookmarks.file]"
	exit
fi

if [ $1 == 'c' ]
then
	cp $2 $HOME/DataDrive/reSystem/Configuration/
	cd $HOME/DataDrive/reSystem/
	git add *
	git commit -a -m $'\n\n--Configuration data uploaded \n\nIssue:100000 \n\n'
elif [ $1 == 'b' ]
then
	cp $2 DataDrive/reSystem/Bookmarks/
	cd $HOME/DataDrive/reSystem/
	git add *
	git commit -a -m $'\n\n--Bookmarks uploaded \n\nIssue:100000 \n\n'
fi

git push
