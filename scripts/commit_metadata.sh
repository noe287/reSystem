#!/bin/bash

function prep_env(){

	if [ ! -d "$PWD/metadata_dir" ]
	then 
		mkdir $PWD/metadata_dir
	fi

	#Grab the most uptodate .tsv file in the directory
	max=0
	for i in `ls $PWD | grep tsv`
	do 
		curr=`stat -c %Y $i`
		if [ $curr -gt $max ] 
		then
			max=$curr
			fname="$i"
		fi
	
	done

	sed -f scr.sed $fname > tmp
	mv tmp $fname

	MY_PATH=$PWD
	GIT_PATH="/home/noe287/Development/projects/FOSS_WORK/Create_Commit_Metadata/git_pkgs"
	CSV_FILE_PATH="$PWD/$fname"
	
	echo "Parsing AirTies FOSS Inventory file:" $CSV_FILE_PATH

	TAG_PATH="http://svn.corp.airties.com/svn/atlantis/packages/tags"
	#TAG_PATH="http://svn.corp.airties.com/svn/atlantis/users/Nejat/packages/tags"
	DEVEL_PATH="http://svn.corp.airties.com/svn/atlantis/packages/devel"
	#DEVEL_PATH="http://svn.corp.airties.com/svn/atlantis/users/Nejat/packages/devel"
	SVN_CI_ADD_MSG="-m $'Issue #29865\n\n--Metadata has been added to the repository.\n\n'"
	SVN_CI_DEL_MSG="-m $'Issue #29865\n\n--Metadata has been deleted from the repository.\n\n'"
	GIT_CI_MSG="-a -m $'\n\n--A new metadata has been added to the repository.\n\nIssue:29865 \n\n'"
}

function check_git_dir(){

	GIT_PACK_PATH=$GIT_PATH"/"$BSYS_DIR		#BSYS_DIR is package's buildsys directory name.e.g "wireless","bootloader" etc...
	echo "	-> Metadata check for GIT repo started."

	if [ ! -d "$GIT_PACK_PATH" ]
	then
		echo "		-> DIR $GIT_PACK_PATH does not exist: CREATE - > git clone starts..."
		git clone ssh://nejatonay.erkose@git.corp.airties.com:29418/$BSYS_DIR $GIT_PACK_PATH
	else
		echo "		* DIR EXISTS for $BSYS_DIR"
	fi

	echo "		* Changing directory to $GIT_PACK_PATH"
}

function del_git_metadata(){
	
	to_del=`ls | grep metadata`
	if [ $to_del ]
	then
		echo "		* Old metadata found on the remote server..."
		echo 	"	$to_del"
		echo "		-> Deleting any old $to_del:	git rm"
		git rm "metadata"
	fi

	echo "		-> Checking out GIT branch $BRANCH_NAME:	git checkout"
	git checkout $BRANCH_NAME
	
	to_del=`ls | grep metadata`
	if [ $to_del ]
	then
		echo "		* Old metadata found on the remote server..."
		echo "		-> Deleting $to_del in sublevel directory"
		git rm *metadata
	fi
	
	git commit -a -m $'\n\n--Old metadata has been deleted from the repository.\n\nIssue:29865 \n\n'
	#git commit $GIT_CI_MSG
	echo "		* Sending commits to the remote server: git push"
	git push	#this will be uncommented in realtime run
	echo "		* File committed to GIT repo."
}



function upload_git_metadata(){

	echo "		* Copying metadata from $MY_PATH to $PWD"
	
	cp $MY_PATH"/"$new_meta_file .
	
	echo "		-> Adding and commiting new file to GIT REPO: git add $new_meta_file; git commit -a -m"
	
	git add $new_meta_file
	git commit -a -m $'\n\n--A new metadata has been added to the repository.\n\nIssue:29865 \n\n'
	#git commit $GIT_CI_MSG
	
	echo "		* Sending commits to the remote server: git push"

	git push	#this will be uncommented in realtime run
	
	echo "		* File committed to GIT repo."
	echo "		** Commiting process finished for $BRANCH_NAME returning back to $MY_PATH."
}

function del_svn_metadata(){

	old_meta_file=`svn ls $SVN_PACK_PATH | grep .metadata`

	#echo "OLD METADATA:$old_meta_file"			#keep for debugging
	#echo "$SVN_PACK_PATH/$old_meta_file $SVN_CI_ADD_MSG"   #keep for debugging

	if [ "$old_meta_file" ] 
	then
	 	echo "		* Found old metadata.Deleting $old_meta_file located in $SVN_PACK_PATH..."
	 	echo "			-> svn del "$SVN_PACK_PATH/$old_meta_file" $SVN_CI_DEL_MSG"
		svn del "$SVN_PACK_PATH/$old_meta_file" -m $'Issue #29865\n\n--Metadata has been DELETED from the repository.\n\n'
		#svn move "$SVN_PACK_PATH/$old_meta_file" "$SVN_PACK_PATH/metadata"
	else
		echo "		* No previously commited metadata to delete in $SVN_PACK_PATH..."
	fi
}

function upload_svn_metadata(){

	existing_file=`svn ls $SVN_PACK_PATH | grep metadata`
	if [ ! $existing_file ]
	then
		echo "		* Uploading new metadata..."
		echo "		* Metadata is being committed to SVN repo..."
		echo "			-> svn import metadata $SVN_PACK_PATH/metadata $SVN_CI_ADD_MSG "

		svn import "$MY_PATH/metadata" "$SVN_PACK_PATH/metadata" -m $'Issue #29865\n\n--Metadata has been ADDED to the repository.\n\n'
		echo "		* File committed."
	else
		echo "		* Nothing to upload metadata already exists on SVN repo."
	fi
}


function upload_metadata() {

	if [[ "$REPO_TYPE" = "GIT" ]]
        then
		if [[ "$repo" = "2" ]] || [[ "$repo" = "" ]]
		then
			#echo "upload_git_metadata"   #for debugging
			check_git_dir
			cd $GIT_PACK_PATH
			del_git_metadata
			#upload_git_metadata
			cd $MY_PATH
		#else
		#	echo "problem uploading git repo metadata"
		fi
	elif [[ "$REPO_TYPE" = "SVN" ]]
	then
		if [[ "$repo" = "1" ]] || [[ "$repo" = "" ]] 
		then
			#echo "upload_svn_metadata"
			echo "	-> Metadata check for SVN repo started."
			if [ "$DEVEL" = "1" ]
			then
				SVN_PACK_PATH=$DEVEL_PATH"/"$BSYS_DIR"/"$BRANCH_NAME
				#old_file="$SVN_PACK_PATH/$BRANCH_NAME.metadata"
			else
				SVN_PACK_PATH=$TAG_PATH"/"$BSYS_DIR"/"$BRANCH_NAME
				#as previously no tag metadata has been added to the repo there is no need to try to erase it.
			fi

			del_svn_metadata
			#upload_svn_metadata
		#else
		#	echo "problem uploading svn repo metadata"
		fi
	else
		echo "REPO_TYPE: $REPO_TYPE. No need to upload any metadata for this branch."
        fi
}

function write_file(){

	echo "PACKAGE_NAME		= $BSYS_DIR" > $1
        echo "VERSION			= $VERSION" >> $1
        echo "SUMMARY_DESCRIPTION	= $SDESC" >> $1
        echo "DETAILED_DESCRIPTION	= \"$DDESC\"" >> $1
        echo "ORIGINAL_FILE_NAME	= $OFNAME" >> $1
        echo "SUPPLIER		= $SUPP" >> $1
        echo "ORIGINATOR		= $ORGN" >> $1
        echo "DOWNLOAD_LOCATION	= $DLOC" >> $1
        echo "ALL_LICENSES		= $ALL" >> $1
        echo "CONCLUDED_LICENSE	= $CONCL" >> $1
        echo "COPYRIGHT_TEXT		= $COPYR" >> $1
        echo "LICENSE_TYPE		= $LTYPE" >> $1
        #echo "LICENSE_CROSS_REFERENCE	= $LCREF" >> $1
        #echo "IS_MODIFIED		= $MODIFIED" >> $1
        echo "OSRB_REVIEW_STATUS	= $OSRB" >> $1
        #echo "COMPLIANCY_ISSUE_LIST	= $CISSUE" >> $1
        #echo "CONTENT_HASH		= $CHASH" >> $1
}

function extract_csv_data(){
	
	DEVEL=1

	BSYS_DIR=`echo -e $LINE | cut -d "|" -f3 | sed -e 's/^ *//g' -e 's/ *$//g'`   	 #Buildsys Folder Name
        VERSION=`echo -e $LINE | cut -d "|" -f4 | sed -e 's/^ *//g' -e 's/ *$//g'`    	 #Version of the package

	REPO_TYPE=`echo -e $LINE | cut -d "|" -f23| sed -e 's/^ *//g' -e 's/ *$//g'`	 #git or svn
 	SVN_LOCATION=`echo -e $LINE | cut -d "|" -f16 | sed -e 's/^ *//g' -e 's/ *$//g'`
	
	LICENSE=`echo -e $LINE | cut -d "|" -f12 | sed -e 's/^ *//g' -e 's/ *$//g'`
	BRANCH_NAME=`echo -e $LINE | cut -d "|" -f21 | sed -e 's/^ *//g' -e 's/ *$//g'` 	 # Devel or Tag name
	MODIFIED=`echo -e $LINE | cut -d "|" -f17 | sed -e 's/^ *//g' -e 's/ *$//g'`  	 # yes or no

	SDESC=`echo -e $LINE | cut -d "|" -f5 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Short description of the package
	DDESC=`echo -e $LINE | cut -d "|" -f6 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Longer descriptipn of the package
	OFNAME=`echo -e $LINE | cut -d "|" -f7 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Original name of the package
	SUPP=`echo -e $LINE | cut -d "|" -f8 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Supplier name
	ORGN=`echo -e $LINE | cut -d "|" -f9 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Originator name
	DLOC=`echo -e $LINE | cut -d "|" -f10 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Download location of the file
	ALL=`echo -e $LINE | cut -d "|" -f11 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # All Licenses found about the package
	CONCL=`echo -e $LINE | cut -d "|" -f12 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Concluded license of the package
	COPYR=`echo -e $LINE | cut -d "|" -f15 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Copyright Notice in the file
	LTYPE=`echo -e $LINE | cut -d "|" -f13 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # License TYPE foss or otherwise
	LCREF=`echo -e $LINE | cut -d "|" -f14 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # License cross reference
	OSRB="NOT_DONE"					 # OSRB review status
	CISSUE=""					 # Compliancy issue list
	CHASH=""					 # Content Hash

}

function define_br_repo_dev() {

	#not used at the moment	
	if [ "$REPO_TYPE" = "SVN" ]
	then
		location_path=`echo $SVN_LOCATION | cut -d "/" -f6,7,8,9`
	
	elif [ "$REPO_TYPE" = "GIT" ]
	then
		location_path=$BRANCH_NAME
	else
			
		location_path="NO-UPLOAD"
	fi
	
	if [ $DEVEL = 1 ] # is a dev branch or a tag
	then
		TYPE="devel"
	else
 		TYPE="tag"
	fi
}

function write_metadata(){
	
	new_meta_file="metadata"
	echo "*Writing to file: "$new_meta_file"..."
	write_file $new_meta_file
}

function define_file_name(){

	if [[ "$BSYS_DIR" = "linux" ]] || [[ "$BSYS_DIR" = "brcm-gw" ]] || [[ "$BSYS_DIR" = "brcm-ap" ]]
 		then
#  			meta_file_rm=`echo $BRANCH_NAME |  sed -e 's|/|_|g'`
  			meta_file=`echo $BRANCH_NAME |  sed -e 's|/|_|g'`".metadata"  #wont be used in the actual commit process just for testing purposes
										      # comment the line out when finished for test work.
			echo " "
 		else
 			meta_file=$BRANCH_NAME".metadata"
 		fi
}

function select_branch_upload() {

		if [ $TYPE = "devel" ]		# not uploading "tag" type branch metadata for the moment
		then		
			echo "*Copying metadata to metadata_dir/"$meta_file"_dev["$i"]"
			cp metadata "metadata_dir/"$meta_file"_dev["$i"]"
			echo "*Checking metadata status for remote branch:$BRANCH_NAME"
# 			upload_metadata  # writes metadata as a simple file called "metadata"
		else
			echo "*Skipping the package upload for:$BRANCH_NAME type:$TYPE"
			echo "*Copying metadata to metadata_dir/"$meta_file"_tag["$i"]"
			cp metadata "metadata_dir/"$meta_file"_tag["$i"]"
			#upload_metadata  # writes metadata as a simple file called "metadata"
		fi
}

function main() {

	i=0
	repo="$1"	 #the first argument to run script can be 1,2,3 or " " for repository selective metadata uploading

	while read LINE; do
		
		echo "  "
		echo "========================================================"
		
		extract_csv_data
		
		if [ ! $BRANCH_NAME ] # field marked as DEVEL_NAME or TAG_NAME on csv file
		then
			BRANCH_NAME=`echo $LINE | cut -d "|" -f22`
			if [ ! $BRANCH_NAME ]
			then
				continue 
			fi
			echo "*$REPO_TYPE:TAG BRANCH"
			DEVEL=0
		else
			echo "*$REPO_TYPE:DEVEL BRANCH"
			DEVEL=1
		fi

		define_br_repo_dev
		write_metadata 			 # with name "metadata"
		define_file_name		 # to keep a local copy of the metadata with name "branch_name", ready in $meta_file

		#echo  $meta_file		#keep for debugging

		select_branch_upload

		echo  $i " : " $BRANCH_NAME"_["$TYPE"]" >> list		#create a full list of branch names
		echo "$i"
		i=$(( $i + 1 ))

	done < $CSV_FILE_PATH
}


prep_env

if [ $1 ]
then
	main $1
else
	main
fi
