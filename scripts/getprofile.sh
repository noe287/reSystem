dirname=$1_`date +%F_%H.%M`
svn co http://svn.corp.airties.com/svn/atlantis/buildsys $dirname
cd $dirname
source environment
#touch $1
#echo $1 > $1
make $1
make co -j8
make modem


