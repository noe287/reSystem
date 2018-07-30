FOLDERCNT=`ls | wc -l`

DIR="."
allDIRS=`ls`
FILTER="filter.txt"
CSCOPEFILES=cscope.files

relevantDirs=(manager air-cdf awf-ng air-bus air-cloud-agent air-wall wireless wireless_tools wireless-controller hostapd wpa_supplicant metrics automesh air_eoe airwpa airlibs statistics-collector)

if [ "$1" == "del" ]
then
	rm $FILTER
	rm cscope*
	rm tags
fi

function __cscope() {

	for i in ${relevantDirs[*]}
	do
		echo "-path $i -prune -o \\" >> $FILTER
	done
	
	echo "-name \"*.[chxsS]\" -print > $CSCOPEFILES ">> $FILTER

	find $DIR < $FILTER > /dev/null

	if [ ! -e "cscope.out" ]
	then
		cscope -b -q > /dev/null
		#cscope -R
	fi
	
	if [ ! -e "tags" ]
	then
		ctags -R > /dev/null
	fi
}

#run cscope
__cscope

vim

exit


/* exit  */
/*   */
/* if [ "$FOLDERCNT" -ge 50 ];then  */
/*   */
/*   */
/* 	for i in $allDIRS;  */
/* 	do  */
/* 		echo "-path $i -prune -o \\" >> $FILTER  */
/* 	done  */
/* 		echo "-name \"*.[chxsS]\" -print > $CSCOPEFILES ">> $FILTER  */
/*   */
/* 	sed -i '/manager/d' $FILTER  */
/* 	sed -i '/air-cdf/d' $FILTER  */
/* 	sed -i '/awf-ng/d' $FILTER  */
/* 	sed -i '/air-bus/d' $FILTER  */
/* 	sed -i '/air-cloud-agent/d' $FILTER  */
/* 	sed -i '/air-wall/d' $FILTER  */
/* 	sed -i '/wireless/d' $FILTER  */
/* 	sed -i '/wireless_tools/d' $FILTER  */
/* 	sed -i '/wireless-controller/d' $FILTER  */
/* 	sed -i '/hostapd/d' $FILTER  */
/* 	sed -i '/wpa_supplicant/d' $FILTER  */
/* 	sed -i '/metrics/d' $FILTER  */
/* 	sed -i '/automesh/d' $FILTER  */
/* 	sed -i '/air_eoe/d' $FILTER  */
/* 	sed -i '/airwpa/d' $FILTER  */
/* 	sed -i '/airlibs/d' $FILTER  */
/* 	sed -i '/statistics-collector/d' $FILTER  */
/*   */
/* 	find $DIR < $FILTER > /dev/null  */
/*   */
/* 	if [ ! -e "cscope.out" ]  */
/* 	then  */
/* 		cscope -b -q > /dev/null  */
/* 		#cscope -R  */
/* 	fi  */
/* 	  */
/* 	if [ ! -e "tags" ]  */
/* 	then  */
/* 		ctags -R > /dev/null  */
/* 	fi  */
/* else  */
/*   */
/* 	if [ ! -e "cscope.out" ]  */
/* 	then  */
/* 		#/* cscope -b -q  */  */
/* 		cscope -R -b > /dev/null  */
/* 	fi  */
/*   */
/* 	if [ ! -e "tags" ]  */
/* 	then  */
/* 		ctags -R > /dev/null  */
/* 	fi  */
/* fi  */
/*   */
