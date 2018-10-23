if [ $1 ]
then
	arg1=$1
else
	exit
fi

CMD="tools/bake"
CMD2="USE_LOCAL_TOOLCHAINS=y tools/bake"

targets=(gemini-419.config booster2.config gemini-419-release.config booster2-release.config mrbox-412.config copperhead.config mrbox-412-release.config copperhead-release.config viper.config falcon-d1.config viper-release.config falcon-d1-release.config xwing-412.config falcon-d1-uhd.config xwing-412-release.config falcon-d1-uhd-release.config)
config=(mrbox-412.config booster2.config falcon-d1.config xwing-412.config viper.config)

if [ "$arg1" == "list" ]
then
	echo ""
	echo "Usage: sky.sh release/head profile_ name cloud/regular [bl:conf:checkout]"
	echo ""
	echo "List of target profiles:"
	for i in ${targets[*]}
	do
		echo $i
	done
	exit
elif [ "$arg1" == "skybuilder" ]
then
	git clone ssh://nejatonay.erkose@git.corp.airties.com:29418/bskyb-shr-builder ${DATE}_${1}_${2}
	exit
fi


if [ "$arg1" == "release" ]
then
	config=(booster2-release.config mrbox-412-release.config viper-cloud-release.config viper-release.config
	falcon-d1-release.config xwing-412-release.config xwing-hip-release.config gemini-419-release.config
	falcon-d1-uhd-release.config)
else
	arg1="HEAD"
	config=(mrbox-412.config booster2.config falcon-d1.config xwing-412.config viper.config)
fi

function choose_config()
{
	echo "choose config"
	for i in ${config[*]}
	do
		echo $i | grep $1

		if [ $? -eq 0 ]
		then
			Profile=$i
			break
		fi
	done
}

if [ $2 ]
then
	arg2=$2
	choose_config $arg2
	DATE=${arg2}"_"`date +%h-%d_%a-%H_%M_%S__%y`

	BUILD_DIR=${DATE}

	git clone ssh://nejatonay.erkose@git.corp.airties.com:29418/bskyb-shr-builder ${BUILD_DIR}
	cd ${BUILD_DIR}


	if [ "$3" == "cloud" ]
	then
		# git checkout bskyb-shr-builder-merge
		git checkout bskyb-shr-builder-Mesh-1.1
	fi

	if [ "$4" == "conf" ] #configure the profile
	then
		echo "Will configure the profile only"
		type="config"
	elif [ "$4" == "co" ] # checkout only
	then
		echo "Will Checkout but won't build"
		type="checkout"
	else
		type="build"  #build the profile
	fi

	echo ${Profile} | grep viper

	if [ $? -eq 0 ]
	then
		CMD=$CMD2
	fi
	echo ${Profile} | grep booster

	if [ $? -eq 0 ]
	then
		CMD=$CMD2
	fi

	eval "$CMD ${Profile}"
	BUILD_TYPE=debug
	export BUILD_TYPE
	echo "----->>>> BUILDING ${Profile}"

	if [ "$type" == "config" ]
	then
		#already uses the config just exit
		vim ./configs/atlantis/"bskyb-"${Profile}
		eval "$CMD ${Profile}"
		exit
	elif [ "$type" == "checkout" ]
	then
		#Checkout the code and configure
		eval "$CMD checkout configure"
	else
		eval "$CMD all"
	fi
else
	echo "Lacking profile name to build! Exiting"
	exit
fi


