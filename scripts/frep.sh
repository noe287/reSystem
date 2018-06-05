#!/bin/bash

#1st part is to gather all required metadata files in "buildsys/package/package_ver"
if [ "$1" = "meta" ]
then
for i in `ls $BSPPATH`
do
		echo $i
        if [ -d $i ]
        then
		#if [[ "$i" = "toolchain" ]] || [[ "$i" = "tmp" ]] || [[ "$i" = "configs" ]] || [[ "$1" = "tools"  ]]
		if [[ "$i" = "tmp" ]] || [[ "$i" = "configs" ]] || [[ "$i" = "tools"  ]] || [[ "$i" = "toolchain" ]]
		#if [[ "$i" = "tmp" ]] || [[ "$i" = "configs" ]] || [[ "$1" = "tools"  ]]
		then
			continue
		fi

		if [ "$2" = "d" ]
		then
			sed -i.bak '/foss_metadata/d'  $BSPPATH/$i/Makefile > /dev/null 2>&1
		else
			if [[  "$i" = "kernel" ]] || [[ "$i" = "busybox" ]]
			then
				sed -i.bak '/foss_metadata/d'  $BSPPATH/$i/Makefile > /dev/null 2>&1
				#sed -i.bak 's/GIT_CO,.*$/&\n	cp \$\{BSPPATH\}\/tools\/fosstools\/foss_metadata\/\$\{target_path\}.metadata \$\{target_path\}\/metadata/' $BSPPATH/$i/Makefile
				sed -i.bak 's/GIT_CO,.*$/&\n	get_metadata.sh \$\{BSPPATH\}\/tools\/fosstools\/foss_metadata\/\*\$\{target_path\}.metadata\* \$\{target_path\}\/metadata/ ' $BSPPATH/$i/Makefile

			elif [[ "$i" = "access-dlna" ]] || [[ "$i" = "samba" ]]
			then
				sed -i.bak '/foss_metadata/d'  $BSPPATH/$i/Makefile > /dev/null 2>&1
				#sed -i.bak 's/path}$/&\n	cp \$\{BSPPATH\}\/tools\/fosstools\/foss_metadata\/\$\{target_path\}.metadata \$\{target_path\}\/metadata/' $BSPPATH/$i/Makefile
				sed -i.bak 's/path}$/&\n	get_metadata.sh \$\{BSPPATH\}\/tools\/fosstools\/foss_metadata\/\*\$\{target_path\}.metadata\* \$\{target_path\}\/metadata/ ' $BSPPATH/$i/Makefile
			else
				sed -i.bak '/foss_metadata/d'  $BSPPATH/$i/Makefile > /dev/null 2>&1
				#sed -i.bak 's/SVN_CO}.*$\|GIT_CO,.*$/&\n	cp \$\{BSPPATH\}\/tools\/fosstools\/foss_metadata\/\$\{target_path\}.metadata \$\{target_path\}\/metadata/' $BSPPATH/$i/Makefile
				sed -i.bak 's/SVN_CO}.*$\|GIT_CO,.*$/&\n	get_metadata.sh \$\{BSPPATH\}\/tools\/fosstools\/foss_metadata\/\*\$\{target_path\}.metadata\* \$\{target_path\}\/metadata/ ' $BSPPATH/$i/Makefile
			fi
		fi
		
		cat $BSPPATH/$i/Makefile | grep CHECKOUT} -A5
		rm $BSPPATH/$i/Makefile.bak 2>/dev/null
	fi
done

elif [ "$1" = "foss" ]
then

#2nd part is to place _foss rule into each Makefile in used packets for this profile
gcc -o release/revision release/revision.c

PACKETS_USED=`release/revision $BSPROOT/. .config | sed -ne 's/^.*][[:space:]]\(.*\)[[:space:]](.*/\1/p' | grep -vie filesystem_product -e filesystem_base -e filesystem_platform -e asp_xmls -e device_tables -e buildsys -e libverify_keys -e bcm9535x -e bcm947xx`

PACKETS_USED+=" toolchain"
UCLIBC_VERSION=`cat .config | sed -ne 's/CONFIG_UCLIBC_VERSION="\(.*\)"/\1/p'`

#echo $PACKETS_USED
BEST_CHAN_VER=`cat $BSPROOT/.config | sed -ne 's/^CONFIG_bestchan_PATH=\"\(.*\)\".*/\1/p'`

for i in $PACKETS_USED
do
	if [ "$2" = "d" ];then

		sed -i '/}_foss/,+6d' $BSPROOT/$i/Makefile > /dev/null 2>&1
		sed -i '/foss_content.sh/,+6d' $BSPROOT/$i/Makefile > /dev/null 2>&1
        	if [ "$i" = "bestchan" ];then
	        	if [ -d $i/$BEST_CHAN_VER ];then
                                sed -i 's|.config|Makefile.build|g' $BSPROOT/$i/$BEST_CHAN_VER/Makefile
                        fi
                fi
	else
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
        	                if [ "$i" = "toolchain" ];then
					echo -e "\t" '@${BSPPATH}/tools/fosstools/foss_content.sh uClibc-'${UCLIBC_VERSION}' ${target_name}' >> "$BSPROOT/$i/Makefile"
				else
                	        	echo -e "\t" '@${BSPPATH}/tools/fosstools/foss_content.sh ${CONFIG_'$i'_PATH} ${target_name}' >> "$BSPROOT/$i/Makefile"
				fi
                		        echo -e "\t" '@true' >> "$BSPROOT/$i/Makefile"
        	                if [ "$i" = "bestchan" ];then
	                                if [ -d $i/$BEST_CHAN_VER ];then
                                	        sed -i 's|Makefile.build|.config|g' $BSPROOT/$i/$BEST_CHAN_VER/Makefile
                        	        fi
                	        fi
        	        fi
	        fi
	fi
done

fi
