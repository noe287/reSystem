#!/bin/bash
#
# Author: Firat Birlik
# Date:   2008
#
# Multi directory selection added // Mahmut 
# Also add makefiles and ignore svn base files // Mahmut

DATE=`date "+%s"`
VAR=""
echo "myscope.sh - kscope wrapper script by Firat Birlik"

if [ "$1" = "" ]; then
	echo "Usage: myscope.sh [src-dir1] <src-dir2> .."
	exit
fi

TMP_FOLDER="/tmp/myscope-$DATE"

for ((i=1; i<= $#; i++))
do

    VAR=${!i};
    if [ "$VAR" = "" ]
    then
	continue;
    fi
    
    if [ "$1" == '.' ]   #when the first argument is simply the current dir '.'
    then
    	TMP_SRC_FOLDER="$PWD/$VAR"
	echo "1rst case"
    elif [ `dirname $1` == '.'  ]  #the first argument is a directory in the current directory "awf or manager"
    then
    	TMP_SRC_FOLDER="$PWD/${VAR}"
	echo "2nd case"
    else
    	TMP_SRC_FOLDER="${VAR}"  #case that when a fullpath of remote directory is given "$SCRIPTS_DIR or /home/noe/
	echo "third case"
    fi


    if [ ! -d ${TMP_SRC_FOLDER} ]; then
	echo "[-] source folder [${TMP_SRC_FOLDER}] not found"
	exit
    fi
    SRC_FOLDER="${SRC_FOLDER} ${TMP_SRC_FOLDER}";

    echo $SRC_FOLDER

done

echo "[+] your source folder(s): $SRC_FOLDER"

mkdir -p $TMP_FOLDER
if [ $? -ne 0 ]; then
	echo "[-] could not create [$TMP_FOLDER]"
	exit
fi

echo "[+] creating file list"
#find ${SRC_FOLDER} -name 'airties*' -or -name 'wl*' -or -name '*.xml' -or -name '*.config' -or -name 'Config' -or -name '*.html' -or -name '*.js' -or -name '*.sh' -or -name '*.txt' -or -name '*.pl' -or -name '*.cpp' -or -name '*.c' -or -name '*.h' -or -name 'Makefile*' -or -name '*.mk' -or -name 'wl' -or -name '*.diff' | grep -v "svn-base" > ${TMP_FOLDER}/cscope.files

find ${SRC_FOLDER} -name '*.xml' -or -name '*.config' -or -name 'Config' -or -name '*.html' -or -name '*.js' -or -name '*.sh' -or -name '*.txt' -or -name '*.pl' -or -name '*.cpp' -or -name '*.c' -or -name '*.h' -or -name 'Makefile*' -or -name '*.mk' -or -name 'wl' -or -name '*.diff' | grep -v "svn-base" > ${TMP_FOLDER}/cscope.files

echo -n "[+] building cross reference ... "
cd ${TMP_FOLDER} && cscope -k -b -i ${TMP_FOLDER}/cscope.files
if [ ! -f ${TMP_FOLDER}/cscope.out ]; then
	echo "[-] cscope.out not created"
	exit
fi
DUR=$((`date "+%s"` - $DATE))
echo "done in $DUR seconds"

echo "[+] launching kscope"
cd ${SRC_FOLDER} && kscope ${TMP_FOLDER}/cscope.out
echo "[+] removing ${TMP_FOLDER}"
rm -rf ${TMP_FOLDER}


