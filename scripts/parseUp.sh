#!/bin/bash

GIT_PATH="/home/noe287/Development/projects/indiv_packets/git_pkgs"
MY_PATH="/home/noe287/Development/projects/indiv_packets/foss"
foss="/home/noe287/Development/projects/indiv_packets/SVN_ALL/foss"

function upload_metadata () {

	if [ "$REPO_TYPE" = "GIT" ]
        then
		PREFIX="/home/noe287/Development/projects/indiv_packets/git_pkgs/"$BSYS_DIR
                echo "Treating $1 for GIT repo"

                if [ -d "$PREFIX" ]; then

                        echo "*DIR EXISTS for $PACK_NAME"       
                        #cp $1 $PREFIX"/"
			echo "*Checking out GIT branch: $PACK_NAME"
			cd $PREFIX
                        git checkout $PACK_NAME
			#git rm $meta_file
                        cp $MY_PATH"/"$1 $PREFIX"/"
			#git add $1
			echo "*Commiting new file:$1"
			#git commit -m $'\n\n--Metadata has been added to the repository.\n\nIssue:29865 \n\n'
			echo "*Sending commits to the remote server: PUSH"
			#git push
                	echo "*File committed to GIT repo."
							
                        cd $MY_PATH

                else
                        echo "*DIR does not exist: CREATE"       
                        git clone ssh://nejatonay.erkose@git.corp.airties.com:29418/$BSYS_DIR $PREFIX
                        cd $PREFIX 		  #cd into the checked out directory
			#git rm $meta_file 	  #rm the previously committed file
                        cp $MY_PATH"/"$1 $PREFIX"/"
                	echo "*Checking out GIT branch:$PACK_NAME"
                        git checkout $PACK_NAME
			#git add $1
			echo "*Commiting new file:$1"
			#git commit -m $'\n\n--Metadata has been added to the repository.\n\nIssue:29865 \n\n'
			echo "*Sending commits to the remote server: PUSH"
			#git push
                	echo "*File committed to GIT repo."
                        cd $MY_PATH
                fi
        else
                echo "Treating $1 for SVN repo"
                PREFIX="/home/noe287/Development/projects/indiv_packets/SVN_ALL/"$BSYS_DIR"_all"
                #echo "svn import $meta_file $SVN_LOCATION $meta_file"
                #if [ $TYPE = "tags" ]; then
                #        SUFFIX=$PACKAGE_GENERIC_NAME"_tags/"$PACK_NAME
                #else
                        SUFFIX=$BSYS_DIR"_dev/"$PACK_NAME
                #fi

                cd $PREFIX"/"$SUFFIX"/"
		#svn rm $meta_file        #rm the previously committed file
                cp $MY_PATH"/"$1 $PREFIX"/"$SUFFIX"/"
                #cp $1 $PREFIX"/"$SUFFIX"/"
                echo "Adding file on SVN and commiting..."
                #svn add $1
                #svn ci -m $'Issue #29865 \n\n--Metadata has been added to the repository.\n\n'
                echo "File committed to SVN repo."
                cd $MY_PATH
        fi
}

function write_file(){

	echo "PACKAGE_NAME 		= $BSYS_DIR" > $1
        echo "VERSION 		= $VERSION" >> $1
        echo "SUMMARY_DESCRIPTION 	= $SDESC" >> $1
        echo "DETAILED_DESCRIPTION 	= \"$DDESC\"" >> $1
        echo "ORIGINAL_FILE_NAME 	= $OFNAME" >> $1
        echo "SUPPLIER 		= $SUPP" >> $1
        echo "ORIGINATOR 		= $ORGN" >> $1
        echo "DOWNLOAD_LOCATION 	= $DLOC" >> $1
        echo "ALL_LICENSES 		= $ALL" >> $1
        echo "CONCLUDED_LICENSE 	= $CONCL" >> $1
        echo "COPYRIGHT_TEXT 		= $COPYR" >> $1
        echo "LICENSE_TYPE 		= $LTYPE" >> $1
        echo "LICENSE_CROSS_REFERENCE = $LCREF" >> $1
        echo "IS_MODIFIED 		= $MODIFIED" >> $1
        echo "OSRB_REVIEW_STATUS 	= $OSRB" >> $1
        echo "COMPLIANCY_ISSUE_LIST 	= $CISSUE" >> $1
        echo "CONTENT_HASH 		= $CHASH" >> $1
}


function main(){

i=0

while read LINE; do

	BRANCH=1
	BSYS_DIR=`echo $LINE | cut -d "," -f3`
        VERSION=`echo $LINE | cut -d "," -f4`

	REPO_TYPE=`echo $LINE | cut -d "," -f23` #git or svn
 	SVN_LOCATION=`echo $LINE | cut -d "," -f16`
	
	LICENSE=`echo $LINE | cut -d "," -f12`
	PACK_NAME=`echo $LINE | cut -d "," -f21`
	MODIFIED=`echo $LINE | cut -d "," -f17` # yes or no

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
	OSRB="Not Done"	
	CISSUE=""	
	CHASH=""	
	
	if [ ! $PACK_NAME ] # field marked as BRANCH_NAME or TAG_NAME on csv file
	then
		PACK_NAME=`echo $LINE | cut -d "," -f22`
		if [ ! $PACK_NAME ]
		then
			 continue 
		fi
		echo "TAG PACKET" 
		BRANCH=0
	fi
	
	
	if [ "$REPO_TYPE" = "SVN" ]
	then
		location_path=`echo $SVN_LOCATION | cut -d "/" -f6,7,8,9`
	else
		location_path=$PACK_NAME
	fi
	
	if [ $BRANCH = 1 ] # is a dev branch or a tag
	then
		TYPE="devel"
	else
 		TYPE="tag"
	fi

	#if [ $TYPE = "devel" ]
	#then
	if [[ "$BSYS_DIR" = "linux" ]] || [[ "$BSYS_DIR" = "brcm-gw" ]] || [[ "$BSYS_DIR" = "brcm-ap" ]]
	then
                       #meta_file_rm=`echo $PACK_NAME |  sed -e 's|/|_|g'`
                       meta_file=`echo $PACK_NAME |  sed -e 's|/|_|g'`".metadata"
	else
		meta_file=$PACK_NAME".metadata"
	fi

	echo "  "
	echo "========================================================"
	echo "Writing to file: "$meta_file"..."
	write_file "metadata/"$meta_file
	sleep 1

	if [ $TYPE = "devel" ]
	then

		echo "Uploading file: "$meta_file"..."
		sleep 1
		upload_metadata "metadata/"$meta_file
		mv "metadata/"$meta_file "metadata/"$meta_file"_dev["$i"]"
		#echo "Removing file: "$meta_file"..."
		#rm "metadata/"$meta_file
		echo "Producing file name for foss folder upload..."
	else
		echo "Skipping the package:$PACK_NAME type:$TYPE"
		mv "metadata/"$meta_file "metadata/"$meta_file"_tag["$i"]"
		echo  $i " : " $PACK_NAME"_["$TYPE"]" >> list
		echo "$i"
		i=$(( $i + 1 ))
		continue
	fi

	#if [[ $BSYS_DIR = "kernel" ]] || [[ "$BSYS_DIR" = "brcm-gw" ]] || [[ "$BSYS_DIR" = "brcm-ap" ]]
	#then
	#	if [ "$PACK_NAME" = "vanillas" ]
	#	then
	#	 	FILE_NAME=$PACK_NAME"_"$BSYS_DIR
	#	else
	#		 FILE_NAME=`echo $PACK_NAME |  sed -e 's|/|_|g'`"_"$BSYS_DIR
	#		 echo "IN FIELD: $PACK_NAME"
	#	fi
	#else 
	#	FILE_NAME=$PACK_NAME
	#fi

	#meta_file=$foss"/"$FILE_NAME"["$TYPE"].metadata"
	#echo "File name create for foss folder upload: $meta_file"
	#echo "Writing to file: "$meta_file"..."
	#write_file $meta_file
	
	echo  $i " : " $PACK_NAME"_["$TYPE"]" >> list
	echo "$i"
	i=$(( $i + 1 ))

done < $MY_PATH/Foss.csv

}

main





