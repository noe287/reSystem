#!/bin/bash

BRANCHNAME=$1   # ex:hostapd/hostapd-version
PACKAGENAME=$2  # ex:hostapd

config=${BSPROOT}"/.config"

PACKAGEPATH="${BSPROOT}/$PACKAGENAME"
BRANCHPATH="${BSPROOT}/$PACKAGENAME/$BRANCHNAME"
FOSS_INFO_FILE=${PACKAGEPATH}"/foss.info"  	#buildsys/packagename/foss.info
metadata1=${PACKAGEPATH}"/metadata" 		#buildsys/packagename/metadata
metadata2=${BRANCHPATH}"/metadata" 		#buildsys/packagename/branchname/metadata

FOSS_TOOLS_PATH=${BSPROOT}"/tools/fosstools/"
FOSSRELEASE_PATH=${BSPROOT}"/release/foss"

tarball_list="${BSPROOT}/tmp/foss_content/tarball_list"
GNU_LICENSES="${BSPROOT}/tmp/foss_content/gnu_licenses"

LICENSE_TEXT_DIR="$FOSS_TOOLS_PATH/license_texts/"

PRODUCT_NAME=`cat $config | sed -ne 's/^CONFIG_PRODUCT_NAME="\(.*\)"/\1/p'` 
RELEASE_VERSION=`cat $config | sed -ne 's/^CONFIG_RELEASE_VERSION="\(.*\)"/\1/p'` 
FOSS_CONTENT_DOCUMENT=${FOSSRELEASE_PATH}/$PRODUCT_NAME"_foss_content_document.txt"

function handle_GPL_LGPL(){
 
        if [ -e "$GNU_LICENSES" ];then
                cat "$GNU_LICENSES" | grep -Fx $CONCLUDED_LICENSE > /dev/null 2>&1
 
                if [ "$?" = "1" ];then
                        echo "$CONCLUDED_LICENSE" >> "$GNU_LICENSES"
                fi
        else
                echo "$CONCLUDED_LICENSE" >> "$GNU_LICENSES"
        fi
 
        if [ -e $tarball_list ];then
                if ! grep ${PACKAGE_NAME} $tarball_list;then
                        echo "${PACKAGE_NAME}" >> $tarball_list # Work to be done later. Contains source list to be opened to the customers.
                fi
        else
                echo "${PACKAGE_NAME}" > $tarball_list # Work to be done later. Contains source list to be opened to the customers.
                
        fi
}

function produce_foss_info(){

    echo "######################################################################################"
    echo ""
    PACKAGE_NAME=`cat $1 | sed -ne 's/^PACKAGE_NAME.*=[[:space:]]*\(.*\)/\1/p'`
    VERSION=`cat $1 | sed -ne 's/^VERSION.*=[[:space:]]*\(.*\)/\1/p'`
    LICENSE_TYPE=`cat $1 | sed -ne 's/^LICENSE_TYPE.*=[[:space:]]*\(.*\)/\1/p'`
    COPYRIGHT=`cat $1 | sed -ne 's/^COPYRIGHT.*=[[:space:]]*\(.*\)/\1/p'`
    CONCLUDED_LICENSE=`cat $1 | sed -ne 's/^CONCLUDED.*=[[:space:]]*\(.*\)/\1/p'`

    echo -e "Package Name:\t${PACKAGE_NAME}" 
    echo -e "Version:\t${VERSION}" 
    echo -e "License Type:\t${CONCLUDED_LICENSE}"
    echo -e "Copyright:\t${COPYRIGHT}"
    
    lic=`echo $CONCLUDED_LICENSE | grep GPL`

    if [ "$?" = "0"  ]; then
		handle_GPL_LGPL
		LGPL_GPL=1
        echo ""
    fi    

    if [ "$LGPL_GPL" != "1" ];then
   
	    if [ -e "${LICENSE_TEXT_DIR}/${CONCLUDED_LICENSE}" ];then
			echo "License Text:"
			echo "------------------------------------------"
			cat "${LICENSE_TEXT_DIR}/${CONCLUDED_LICENSE}"
    		echo ""
	    else
			echo "Cannot find ${CONCLUDED_LICENSE} license text file for package: ${PACKAGE_NAME}"
	    fi
    fi

}

function process_metadata(){

	if [ -e $metadata2 ]; then
		metadata=$metadata2
	elif [ -e $metadata1 ]; then
		metadata=$metadata1
        #echo "Buildsys level metadata is processed. $metadata"
	else
		echo "Directory does not contain any metadata."
		exit
	fi
	TYPE=`cat $metadata | grep LICENSE_TYPE | cut -d "=" -f2 | tr -d ' ' `
   	if [ "$TYPE" = "FOSS" ]; then
   		produce_foss_info $metadata  >> $FOSS_INFO_FILE
   		tar_source_code ${PACKAGENAME} > /dev/null 2>&1
	else
		echo "Nothing to do;not a FOSS package"
	fi
}

function tar_source_code(){
	
	if [ ! -d ${FOSSRELEASE_PATH}/foss ];then
		mkdir -p ${FOSSRELEASE_PATH}/foss
	fi

	tar -zcvf "${FOSSRELEASE_PATH}/${PACKAGENAME}.tar.gz" -C ${BSPROOT} ${PACKAGENAME} --exclude='.svn' --exclude='.git' --exclude='*.so' --exclude='*.a' --exclude='*.o' --exclude='*~' --exclude='Config' --exclude='foss.info'
}

function collect_foss_info(){
	find $BSPROOT -mindepth 1 -maxdepth 1 -type d | while read -r PACKAGEPATH
	do
		if [ -d $PACKAGEPATH ]; then
			PACKAGENAME=`basename $PACKAGEPATH`
			if [ "$PACKAGENAME" = "buildsys" -o "$PACKAGENAME" = "kernel" ]; then
			   continue
			else
				if [ -e "$PACKAGEPATH/foss.info" ]; then
					cat "$PACKAGEPATH/foss.info"
				else
					make -C $PACKAGEPATH foss > /dev/null 2>&1
					if [ -e "$PACKAGEPATH/foss.info" ]; then
						cat "$PACKAGEPATH/foss.info"
					fi
				fi
			fi
		fi
	done
}

function clean_folders(){

	rm $FOSS_CONTENT_DOCUMENT > /dev/null 2>&1
	rm $fw_pack_list > /dev/null 2>&1
	
	rm -rf ${FOSSRELEASE_PATH}
	mkdir -p ${FOSSRELEASE_PATH}

	if [ -d $BSPROOT/tmp/foss_content ];then
		rm -f $BSPROOT/tmp/foss_content/* 
	else
		mkdir -p $BSPROOT/tmp/foss_content
	fi

	find $BSPROOT -mindepth 1 -maxdepth 1 -type d | while read -r PACKAGEPATH
	do
		PACKAGENAME=`basename $PACKAGEPATH`
		if [ -e $BSPROOT/$PACKAGENAME/foss.info ];then
			rm $BSPROOT/$PACKAGENAME/foss.info
		fi
	done
}

function prepare_foss_content_document(){
	echo "-------------------------------------------------------------------------------------"
	echo ""
	echo "		FOSS CONTENT DOCUMENT FOR AirTies ${PRODUCT_NAME}-${RELEASE_VERSION}"
	echo ""
	echo "-------------------------------------------------------------------------------------"

	collect_foss_info

	LGPL_GPL_SET=`cat $GNU_LICENSES`

	if [ "$LGPL_GPL_SET" != "" ];then
		echo "######################################################################################" 
		echo ""
		echo "--------------------------------------------------------------------------------------"
		echo " 		Licenses for GPL and LGPL code                             				 		"
		echo "--------------------------------------------------------------------------------------"
		echo ""

		for lic in $LGPL_GPL_SET; do
    		if [ -e "${LICENSE_TEXT_DIR}/$lic" ]; then
				echo "" 
				cat "${LICENSE_TEXT_DIR}/$lic"
				echo "######################################################################################"
				echo "" 
	        else
			 	#echo "No license text file exists under $LICENSE_TEXT_DIR for $lic"
				echo""
		    fi
		done
		#rm "$GNU_LICENSES" > /dev/null 2>&1
	fi

}

if [ "$1" = "collect" ]; then
	clean_folders
	echo "Collect licenses and tarballs of open source packages"
	prepare_foss_content_document >> $FOSS_CONTENT_DOCUMENT
else
	rm $FOSS_INFO_FILE > /dev/null 2>&1
	process_metadata #> /dev/null 2>&1
fi
