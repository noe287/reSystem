#!/bin/bash


# |Nejat Erköse|manager|manager-1.11|AirTies Manager|AirTies Software Platform Main Source Files|manager-1.11|AirTies|AirTies|AirTies|AirTies|AirTies|AirTies||Copyright (c)  AirTies Wireless Networks|git://git.corp.airties.com/manager|NO|||||manager-1.11|GIT|
PIPED_FILE=inventory_piped.txt

IGNORE_DIR="xupnpd ti_voip tapi swisscom_rnas provision libverify-keys fwrecover dmalloc ar7_dsl filesystem_product filesystem_base filesystem_platform kernel asp_xmls device_tables libverify_key xupnpd ti_voip"

IGNORE_LIC="GPL GPL-2.0 GPL-3.0 LGPL-2.0 LGPL-2.1 LGPL-3.0 AFL-2.1 MLP-1.0 CC-BY-SA-3.0 TRANSMISSIONbt MSNTP"
INIT_DIR=$PWD



function prep_env(){

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

	echo "FILE NAME:$fname : $INIT_DIR"

	sed -f scr.sed $fname > tmp
	mv tmp $PIPED_FILE

}

function define_br_repo_dev() {

	#not used at the moment	
# 	if [ "$REPO_TYPE" = "SVN" ]
# 	then
# 		location_path=`echo $SVN_LOCATION | cut -d "/" -f6,7,8,9`
# 	
# 	elif [ "$REPO_TYPE" = "GIT" ]
# 	then
# 		location_path=$BRANCH_NAME
# 	else
# 			
# 		location_path="NO-UPLOAD"
# 	fi
	
	if [ $DEVEL = 1 ] # is a dev branch or a tag
	then
		TYPE="devel"
	else
 		TYPE="tag"
	fi
}



function extract_csv_data(){
	
	DEVEL=1

	BSYS_DIR=`echo -e $LINE | cut -d "|" -f3 | sed -e 's/^ *//g' -e 's/ *$//g'`   	 #Buildsys Folder Name
#       VERSION=`echo -e $LINE | cut -d "|" -f4 | sed -e 's/^ *//g' -e 's/ *$//g'`    	 #Version of the package

	REPO_TYPE=`echo -e $LINE | cut -d "|" -f23| sed -e 's/^ *//g' -e 's/ *$//g'`	 #git or svn
 	SVN_LOCATION=`echo -e $LINE | cut -d "|" -f16 | sed -e 's/^ *//g' -e 's/ *$//g'`
	
# 	LICENSE=`echo -e $LINE | cut -d "|" -f12 | sed -e 's/^ *//g' -e 's/ *$//g'`
	BRANCH_NAME=`echo -e $LINE | cut -d "|" -f21 | sed -e 's/^ *//g' -e 's/ *$//g'` 	 # Devel or Tag name
# 	MODIFIED=`echo -e $LINE | cut -d "|" -f17 | sed -e 's/^ *//g' -e 's/ *$//g'`  	 # yes or no

# 	SDESC=`echo -e $LINE | cut -d "|" -f5 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Short description of the package
# 	DDESC=`echo -e $LINE | cut -d "|" -f6 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Longer descriptipn of the package
# 	OFNAME=`echo -e $LINE | cut -d "|" -f7 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Original name of the package
# 	SUPP=`echo -e $LINE | cut -d "|" -f8 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Supplier name
# 	ORGN=`echo -e $LINE | cut -d "|" -f9 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Originator name
# 	DLOC=`echo -e $LINE | cut -d "|" -f10 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Download location of the file
# 	ALL=`echo -e $LINE | cut -d "|" -f11 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # All Licenses found about the package
	CONCL=`echo -e $LINE | cut -d "|" -f12 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Concluded license of the package
# 	COPYR=`echo -e $LINE | cut -d "|" -f15 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # Copyright Notice in the file
# 	LTYPE=`echo -e $LINE | cut -d "|" -f13 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # License TYPE foss or otherwise
# 	LCREF=`echo -e $LINE | cut -d "|" -f14 | sed -e 's/^ *//g' -e 's/ *$//g'`		 # License cross reference
# 	OSRB="NOT_DONE"					 # OSRB review status
# 	CISSUE=""					 # Compliancy issue list
# 	CHASH=""					 # Content Hash

}


function main() {

	i=0
# 	repo="$1"	 #the first argument to run script can be 1,2,3 or " " for repository selective metadata uploading

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

		echo $IGNORE_DIR | grep "$BSYS_DIR"
		dir=$?		

		echo $IGNORE_LIC | grep "$CONCL"
		concl=$?

		echo "$BSYS_DIR --> $CONCL ---> $concl --> $dir"

		if [ "$dir" = "0" -o "$concl" = "0" ]
		then	
			echo "***FILTERING OUT $BRANCH_NAME"
# 			echo "	-removing $BRANCH_NAME"
# 			rm -rf repository/$BRANCH_NAME
			continue

		fi

		branch_name=$BRANCH_NAME

		echo $BRANCH_NAME : $REPO_TYPE : $SVN_LOCATION
		echo " "
		cd repository


		if [ ! -e $BRANCH_NAME ]
		then		
			if [ "$REPO_TYPE" = "SVN" ]
			then
				svn co $SVN_LOCATION $BRANCH_NAME

			elif [ "$REPO_TYPE" = "GIT" ]
			then
				if [ "$BSYS_DIR" = "brcm-gw" -o "$BSYS_DIR" = "brcm-ap" ]
				then
					echo $BRANCH_NAME | grep /
					if [ $? = 0 ]
					then
						echo "*** Adjusting the name for $BRANCH_NAME"		
						BRANCH_NAME=`echo $BRANCH_NAME |  sed -e 's|/|_|g'`
						if [ -e $BRANCH_NAME ] 
						then
							echo "$BRANCH_NAME exists skipping..."
							cd $INIT_DIR
							continue
						fi
						echo "*** Dirname Adjusted as:$BRANCH_NAME"	
					fi
				fi

				echo "*** Creating the directory as:$BRANCH_NAME"
				mkdir $BRANCH_NAME
				cd $BRANCH_NAME
				echo "*** Checking out the package:$BSYS_DIR"
				git_co.sh $BSYS_DIR
				cd $BSYS_DIR
				echo "*** Switching to $branch_name"
				git checkout $branch_name
# 				cd $INIT_DIR	
			fi
		else
			echo "$BRANCH_NAME exists skipping..."
  		fi

		cd $INIT_DIR	
		
		


# 		echo  $i " : " $BRANCH_NAME"_["$TYPE"]" >> list		#create a full list of branch names
# 		echo "$i"
# 		i=$(( $i + 1 ))

	done < $PIPED_FILE
}

if [ ! -e inventory_piped.txt ]
then
	prep_env
fi
# 
# if [ $1 ]
# then
# 	main $1
# else
	main
# fi

# rm inventory.tsv_piped.txt