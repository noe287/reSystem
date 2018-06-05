DATE=`date +%d_%m_%y-%H.%M.%S`
release=0

CMD="tools/bake"
CMD2="USE_LOCAL_TOOLCHAINS=y tools/bake"

targets=(gemini-419.config booster2.config gemini-419-release.config booster2-release.config mrbox-412.config copperhead.config mrbox-412-release.config copperhead-release.config viper.config falcon-d1.config viper-release.config falcon-d1-release.config xwing-412.config falcon-d1-uhd.config xwing-412-release.config falcon-d1-uhd-release.config)
config=(mrbox-412.config booster2.config falcon-d1.config xwing-412.config viper.config)

if [ "$1" == "skybuilder" ]
then
	git clone ssh://nejatonay.erkose@git.corp.airties.com:29418/bskyb-shr-builder ${DATE}_${1}_${2}
	exit
elif [ "$1" == "release" ]
then
	config=(booster2-release.config mrbox-412-release.config viper-release.config falcon-d1-release.config xwing-412-release.config xwing-hip-release.config gemini-419-release.config falcon-d1-uhd-release.config)
	release=1
elif [ "$1" == "list" ]
then
	echo ""
	echo "usage: sky.sh profile_name or sky.sh release release_profile_name"
	echo ""
	echo "List of target profiles:"
	for i in ${targets[*]}
	do
		echo $i
	done
	exit
fi

function choose_config() {
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

if [ $1 ]
then
	if [ "$release" == "1" ]
	then
		choose_config $2
		BUILD_DIR=${DATE}_${2}_"release"
		if [ "$3" == "conf" ] #configure the profile
		then
			echo "Will configure the profile only"
			type="config"
		elif [ "$3" == "co" ] # checkout only
		then
			echo "Will Checkout but won't build"
			type="checkout"
		else
			type="build"  #build the profile
		fi

	else
		choose_config $1
		BUILD_DIR=${DATE}_${1}
	fi
	# git clone ssh://git.corp.airties.com/bskyb-shr-builder 	
	git clone ssh://nejatonay.erkose@git.corp.airties.com:29418/bskyb-shr-builder ${BUILD_DIR}

	cd ${BUILD_DIR}
	echo "----->>>> BUILDING ${Profile}"

	# below line uses the config indicated
	# if [[]] || [[  ]]
	# then
	# 	CMD=$CMD2
	# fi
	eval "$CMD ${Profile}"
	BUILD_TYPE=debug 
	export BUILD_TYPE

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
fi 

