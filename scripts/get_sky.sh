GIT_TARGET="ssh://nejatonay.erkose@git.corp.airties.com:29418/bskyb-shr-builder"

SVN_URL="http://svn.corp.airties.com/svn/atlantis/users/giray/SkyHybridBuildSTB"
date=`date +%F_%H.%M`

if [ $1 = "viper" ]
then
	dir="VIPER_$date"
	#svn co $SVN_URL $dir
	git clone -b master $GIT_TARGET $dir
	make_profile="viper.config"

elif [ $1 = "booster" ]
then
	dir="BOSSTER_$date"
	#svn co $SVN_URL $dir
	git clone -b master $GIT_TARGET $dir
	make_profile="booster2.config"
elif [ $1 = "falcon" ]
then
	dir="FALCON_$date"
	#svn co $SVN_URL $dir
	git clone -b master $GIT_TARGET $dir
	make_profile="falcon.config"

elif [ $1 = "falcond" ]
then
	dir="FALCON-D1_$date"
	#svn co $SVN_URL $dir
	git clone -b master $GIT_TARGET $dir
	make_profile="falcon-d1.config"

elif [ $1 = "mr" ]
then
	dir="MRBOX_$date"
	#svn co $SVN_URL $dir
	git clone -b master $GIT_TARGET $dir
	make_profile="mrbox.config"

elif [ $1 = "xwing" ]
then
	dir="XWING_$date"
	#svn co $SVN_URL $dir
	git clone -b master $GIT_TARGET $dir
	make_profile="xwing.config"
else
	echo "Usage get_sky.sh [viper || falcon || mr]"
	exit
fi
	
cd $dir
make $make_profile && make checkout && make all && make install
#make $make_profile && make checkout && make bsp-all && make install

if [ $1 = "viper" ]
then
	echo "\n Upload the build file with: \n \t\t f 192.168.1.77:bcmBSKYB_VIPER_fs_kernel \n \t\t or f 192.168.2.77:bcmBSKYB_VIPER_fs_kernel"
fi

exit
