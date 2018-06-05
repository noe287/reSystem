#!/bin/bash

gcc -o release/revision release/revision.c

PACKETS_USED=`release/revision $BSPROOT/. .config | sed -ne 's/^.*][[:space:]]\(.*\)[[:space:]](.*/\1/p' | grep -vie filesystem_product -e filesystem_base -e filesystem_platform -e kernel -e asp_xmls -e device_tables -e buildsys -e libverify_keys -e bcm9535x -e bcm947xx`

BEST_CHAN_VER=`cat $BSPROOT/.config | sed -ne 's/^CONFIG_bestchan_PATH=\"\(.*\)\".*/\1/p'`

#for i in $PACKETS_USED;do sed -i '/}_foss/,+6d'  $BSPROOT/$i/Makefile > /dev/null 2>&1;sed -i '/foss_content.sh/,+6d' $BSPROOT/$i/Makefile > /dev/null 2>&1;done

for i in $PACKETS_USED
do
	if [ -d $i ]
	then
		#echo $i
		#cd $i
		#sed -i 's|foss.sh|@${BSPPATH}/tools/fosstools/foss.sh|g' Makefile
		#cd ..
		
		cat $BSPROOT/$i/Makefile | grep "}_foss" > /dev/null 2>&1
		if [ $? = 1 ];then

			echo " " >> "$BSPROOT/$i/Makefile"
			echo '${target_name}_foss:' >> "$BSPROOT/$i/Makefile"
	        	echo -e "\t" '@${BSPPATH}/tools/fosstools/foss_content.sh ${CONFIG_'$i'_PATH} ${target_name}' >> "$BSPROOT/$i/Makefile"
		        echo -e "\t" '@true' >> "$BSPROOT/$i/Makefile"
	
			if [ "$i" = "bestchan" ];then
				if [ -d $i/$BEST_CHAN_VER ];then
					sed -i 's|Makefile.build|.config|g' $BSPROOT/$i/$BEST_CHAN_VER/Makefile				
				fi
			fi
		fi
	fi	
done

