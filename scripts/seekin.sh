find . -name "$1*" |  grep -v "No such file or directory" | xargs grep $2
