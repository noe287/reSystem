if [ $1 = "-v" ]
then
git-cola &
elif [ $1 = "-vv" ]
then
git-cola &
git commit -a && gitk .&
exit
fi

git commit -a 
