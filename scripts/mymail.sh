
if [ $1 = "me" ]
then
    echo $2 | mail -s "Homework" noe287@gmail.com 
    exit
fi

mail -s "$1" $2 < $3
