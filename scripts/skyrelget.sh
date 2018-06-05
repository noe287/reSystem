#!/bin/bash

clear_proxy()
{
    X=`env | grep proxy | cut -d '=' -f1`
    for Y in $X; 
    do
	echo "unsetting $Y"
	unset $Y
    done

}


clear_proxy

PRODUCTS="viper booster2 falcon-d1 mrbox-412 xwing-412 gemini-419 falcon-d1-uhd xwing-hip"

SERVER_PATH=http://buildbot.corp.airties.com/images/DailyBuilds

echo "number of params is $#"
if [ $# -gt 0 ]; then
    DT=$1
else
    DT=`LANG=en_US date +%d-%b-%Y`
fi

mkdir -p $DT

for P in $PRODUCTS
do
    mkdir -p $DT/$P
    PROFILE_NAME=$P-release
    BUILD_NAME=`wget --no-proxy -qO- $SERVER_PATH/$PROFILE_NAME | grep "$DT" | head -n 1 | cut -d'=' -f 5 | cut -d '"' -f 2`
    FILES=`wget --no-proxy -qO- $SERVER_PATH/$PROFILE_NAME/$BUILD_NAME | grep href | grep "<tr><td" | grep -v "Parent Directory" | cut -d '"' -f 8`

    for F in $FILES
    do
	FILE_PATH=$SERVER_PATH/$PROFILE_NAME/$BUILD_NAME$F
	echo FILE_PATH:$FILE_PATH

	wget --no-proxy $FILE_PATH -O $DT/$P/$F
    done
done
