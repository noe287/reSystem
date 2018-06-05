#!/bin/sh

if [ $# -ne 2 ];then
	echo "Missing parameters!"
	echo "Example use: braman.sh automesh automesh-2.0"
	exit
fi
	

COLOR_RED="\e[31m"
COLOR_GREEN="\e[32m"
COLOR_DEFAULT="\e[39m"


profiles="booster2 viper falcon-d1 gemini-419 mrbox-412 xwing-412 xwing-hip falcon-d1-uhd"

target_package=$1
target_revision=$2

for target in $profiles; do
	echo "Processing $target profile."
	target_config=`find . -name "bskyb-$target-release.config"`

	if [ "$target_config" != "" ]; then
		echo "found the config file for $target"
		#config_content=`cat $target_config`
		#echo "cont: $config_content"
		result=`grep $target_package"_PATH" $target_config -r|awk -F "=" '{print $2}'|awk -F "\"" '{print $2}'`
		if [ "$result" != "" ]; then
			# need to make sure there are no multiple matches (very unlikely but still possible)
			echo -e "Replacing $COLOR_RED$result$COLOR_DEFAULT with $COLOR_GREEN$target_revision$COLOR_DEFAULT in $target_config"
			`sed -i "s/$result/$target_revision/g" $target_config`
			if [ $? -eq 0 ]; then
				echo "Succeeded"
			fi
		fi
	fi
done
