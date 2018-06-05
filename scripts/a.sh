config=(mrbox-412-release.config xwing-412-release.config gemini-419-release.config falcon-d1-uhd-release.config xwing-hip-release.config
booster2-release.config viper-release.config)
targets=(mrbox xwing-412 gemini-419 falcon-d1-uhd xwing-hip booster2 viper)

k=0
for i in ${config[*]}
do

echo $i ${targets[$k]} 
DIR=${targets[$k]}
git clone git://git.corp.airties.com/bskyb-shr-builder $DIR
cd $DIR
git checkout 2017w40
make $i
make checkout configure #all
cd ..
((k++))
done


git clone git://git.corp.airties.com/bskyb-shr-builder mrbox
cd mrbox
git checkout 2017w40
make mrbox-412-release.config
make checkout configure


git clone git://git.corp.airties.com/bskyb-shr-builder xwing-412
cd xwing-412
git checkout 2017w40
make xwing-412-release.config
make checkout configure


git clone git://git.corp.airties.com/bskyb-shr-builder xwing-hip
cd xwing-hip
git checkout 2017w40
make mrbox-hip-release.config
make checkout configure


Done
------------------------------------
git clone git://git.corp.airties.com/bskyb-shr-builder viper
cd viper
git checkout 2017w40
make viper-release.config
make checkout configure
------------------------------------
Not Done
------------------------------------
vi Makefile değişikillerden sonra alttaki commitler gerekli
docker commits needed
docker save    needed
------------------------------------



git clone git://git.corp.airties.com/bskyb-shr-builder falcon-d1-uhd && 
cd falcon-d1-uhd
git checkout 2017w40 &&
make falcon-d1-uhd-release.config &&
make checkout configure


git clone git://git.corp.airties.com/bskyb-shr-builder gemini-419
cd gemini-419
git checkout 2017w40
make gemini-419-release.config
make checkout configure

