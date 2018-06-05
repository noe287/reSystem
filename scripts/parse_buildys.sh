#!/bin/bash

GIT_PATH="/home/noe287/Development/projects/indiv_packets/git_pkgs"
MY_PATH="/home/noe287/Development/projects/indiv_packets/foss"
foss="/home/noe287/Development/projects/indiv_packets/SVN_ALL/foss"
IMPORT_PATH="http://svn.corp.airties.com/svn/atlantis/users/Nejat/packages"
TAG_PATH="http://svn.corp.airties.com/svn/atlantis/users/Nejat/packages/tags/"
DEVEL_PATH="http://svn.corp.airties.com/svn/atlantis/users/Nejat/packages/devel/"

function upload_metadata () {

       echo "Treating $1 for SVN repo"
       PREFIX="/home/noe287/Development/projects/Nejat/buildsys_test"
       SUFFIX=$BSYS_DIR

       cd $PREFIX"/"$SUFFIX"/"
       cp $MY_PATH"/"$1 $PREFIX"/"$SUFFIX"/"
       echo "Adding file on SVN and commiting..."
       #svn add $1
       #svn ci -m $'Issue #29865 \n\n--Metadata has been added to the repository.\n\n'
       #svn import $1 $DEVEL_PATH/$package_name/$1 -m $'Issue #29865 \n\n--Metadata has been added to the repository.\n\n'
       echo "File committed to SVN repo."
       cd $MY_PATH
}

function write_file(){

	echo "PACKAGE_NAME 		= $BSYS_DIR" > $1
        echo "VERSION 			= $VERSION" >> $1
        echo "SUMMARY_DESCRIPTION 	= $SDESC" >> $1
        echo "DETAILED_DESCRIPTION 	= \"$DDESC\"" >> $1
        echo "ORIGINAL_FILE_NAME 	= $BSYS_DIR" >> $1
        echo "SUPPLIER 			= $SUPP" >> $1
        echo "ORIGINATOR 		= $ORGN" >> $1
        echo "DOWNLOAD_LOCATION 	= $DLOC" >> $1
        echo "ALL_LICENSES 		= $ALL" >> $1
        echo "CONCLUDED_LICENSE 	= $CONCL" >> $1
        echo "COPYRIGHT_TEXT 		= $COPYR" >> $1
        echo "LICENSE_TYPE 		= $LTYPE" >> $1
        echo "LICENSE_CROSS_REFERENCE 	= $LCREF" >> $1
       # echo "IS_MODIFIED 		= $MODIFIED" >> $1
       # echo "OSRB_REVIEW_STATUS 	= $OSRB" >> $1
       # echo "COMPLIANCY_ISSUE_LIST 	= $CISSUE" >> $1
       # echo "CONTENT_HASH 		= $CHASH" >> $1

}


function main(){

i=0

while read LINE; do

	BSYS_DIR=`echo $LINE | cut -d "," -f3`

	if [ "$DIR_CHECK" = "$BSYS_DIR" ] 
	then
		continue
	fi

	REPO_TYPE=`echo $LINE | cut -d "," -f23` #git or svn
 	SVN_LOCATION=`echo $LINE | cut -d "," -f16`
	
	LICENSE=`echo $LINE | cut -d "," -f12`
	PACK_NAME=`echo $LINE | cut -d "," -f21`
	VERSION=`echo $LINE | cut -d "," -f4`	
	SDESC=`echo $LINE | cut -d "," -f5`	
	DDESC=`echo $LINE | cut -d "," -f6`	
	OFNAME=`echo $LINE | cut -d "," -f7`	
	SUPP=`echo $LINE | cut -d "," -f8`	
	ORGN=`echo $LINE | cut -d "," -f9`	
	DLOC=`echo $LINE | cut -d "," -f10`	
	ALL=`echo $LINE | cut -d "," -f11`	
	CONCL=`echo $LINE | cut -d "," -f12`	
	COPYR=`echo $LINE | cut -d "," -f15`	
	LTYPE=`echo $LINE | cut -d "," -f13`	
	LCREF=`echo $LINE | cut -d "," -f14`	
	MODIFIED=`echo $LINE | cut -d "," -f17` # yes or no
	OSRB="Not Done"	
	CISSUE=""	
	CHASH=""	

	#meta_file="METADATA_"$BSYS_DIR
	meta_file="metadata"

	echo "  "
	echo "========================================================"
	echo "Writing to file: "$meta_file"..."
	#write_file "metadata/buildsys_metadata/"$meta_file
	write_file $meta_file
	sleep 1

	echo "Uploading file: "$meta_file"..."
	sleep 1
	upload_metadata $meta_file
	
	echo "$i"
	i=$(( $i + 1 ))
	DIR_CHECK=$BSYS_DIR

done < $MY_PATH/Foss.csv

}

main





