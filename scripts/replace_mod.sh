#!/bin/bash

package=`pwd | cut -d "/" -f8`
pub_pack="air-common air_bridge_igmpsnoop air_env air_led air_turbonet air_watchdog"


branches=`git branch -a`
message="\n\nGPL license converted to Proprietary\n\nIssue:$1 \n\n"

for j in $branches
do
	flag=0

	echo $j | grep HEAD

	if [ $? = 0 ]
	then
		flag=1
	fi
	
	echo $j | grep "-"

	if [ $? = 1 ]
	then
	#	flag=1
		a=1
	fi

#	echo "one $flag"	

	if [ $flag = "1" ]
	then
   		continue
	else
        	j=`echo $j | cut -d "/" -f3`
		
		git co $j
	
		feed=`grep -rni MODULE_LICENSE . | cut -d ':' -f1 | grep -v html`
		
		echo "On branch $j"
	
		for i in $feed
		do
		    echo $i
		    sed -i 's|MODULE_LICENSE("GPL")|MODULE_LICENSE("Proprietary")|g' $i
		done

		grep -rni MODULE_LICENSE .
		echo ""		
		echo "Commiting changes on $j"
		git commit -a -m $'\n\nGPL license converted to Proprietary\n\nIssue:FOSS-130 \n\n'
		#git commit -a -m "$message"

		echo "Sending to remote server for:$j"
		echo $pub_pack | grep $package

		if [ $? = 0 ]
		then
			echo "PUB comes:$j"
			git pub
		else
			echo "PUSH comes:$j"
			git push
		fi
	fi	

done

exit

GPL license converted to Proprietary


Issue:FOSS-54


  remotes/origin/aswconfig-1.3-bcm4718-bcm53115_1.0.0.60
  remotes/origin/aswconfig-1.3-rtl83x5
  remotes/origin/aswconfig-1.3_igmpsnooping

