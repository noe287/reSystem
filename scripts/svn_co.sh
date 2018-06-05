#!/bin/bash

BSYS="http://svn.corp.airties.com/svn/atlantis"
refBSYS="/home/nejat/Development/projects/PROFILES/buildsys"
pkgInfoPath="/home/nejat/Development/projects/PROFILES/indiv_packets/SVN_ALL/pkgInfo"

usage() {
	echo ""
	echo "Usage: svn_co.sh tag | dev | bl | co     [ package || profile name ]"
	echo ""
	echo "Ex: svn_co.sh tag hostapd            Downloads all hostapd packages under tags."
	echo "Ex: svn_co.sh dev hostapd            Downloads all hostapd packages under devel."
	echo "Ex: svn_co.sh all hostapd            Downloads all hostapd devel and tag packages."
	echo "Ex: svn_co.sh all			   Checks out all dev and tag packages on SVN "
	echo "Ex: svn_co.sh co Air4641SW           Checks out Air4641SW profile and src files but does not build it."
	echo "Ex: svn_co.sh bl Air4641SW           Checks out and builds Air4641SW profile."
	echo ""
}


if [ $# -lt 1 ]
then
   usage
   exit
fi


if [[ $1 = "tags" ]] || [[ $1 = "devel" ]] && [[ $2 ]] && [[ $3 ]]
then
	dirname="$2_$3"
	REPO="${BSYS}/packages/$1/$2/$3"
	svn co ${REPO} $dirname
	

elif [ $1 = "tag" ] #download a package from the tags branch.
then
	dirname="$2_tags"
	REPO=${BSYS}"/packages/tags/"$2
	svn co ${REPO} $dirname

elif [ $1 = "dev" ] #download a package from the development branch.
then
	dirname="$2_devel"
	REPO=${BSYS}"/packages/devel/"$2
	svn co ${REPO} $dirname

elif [ $1 = "bl" ] #download and build the profile.
then
	dirname=$2_`date +%F_%H.%M`
	REPO=${BSYS}"/buildsys"
	svn co ${REPO} $dirname
	cd $dirname
	source environment

	if [ "$2" = "Air4820" ]
	then
		USE_PROFILES_PACKAGE=y make $2 
	else
		make $2
	fi

	make co -j3
	make modem

elif [ $1 = "co"  ] #download the profile source files and make, but don't build it.
then
	dirname=$2_`date +%F_%H.%M`
	REPO=${BSYS}"/buildsys"
	svn co $rev ${REPO} $dirname
        cd $dirname
	source environment
	make $2
	make co -j3
elif [ $1 = "get"  ] #download the profile source files and make, but don't build it.
then
        dirname=$2_`date +%F_%H.%M`
        REPO=${BSYS}"/buildsys"
        svn co $rev ${REPO} $dirname
        #cd $dirname
        #source environment
        #make $2
        #make co -j8

elif [ $1 = "bsys"  ] #download buildsys only
then
        REPO=${BSYS}"/buildsys"
	if [ $3 ] 
	then
	  rev="-r$3"
	  dirname="$2_"`date +%F_%H.%M`"_$rev"
	else
	  dirname="$2_"`date +%F_%H.%M`
	fi
        svn co $rev ${REPO} $dirname
        cd $dirname


elif [ $1 = "all" ]
then
	if ! [ $2 ] 
	then
		outdir="SVN_ALL"
		pkgInfo="pkgInfo"

		if ! [ -d "$outdir" ];then
		   mkdir $outdir
		fi

		cd $outdir
		
		if ! [ -d "$pkgInfo" ];then
                   mkdir $pkgInfo
                fi

		for D in `ls ${refBSYS}`
		do
			dirname=$D"_all"

			if [ -d "$dirname" ]; then
			echo "=========================EXISTING PACKAGE Updating: $D =============================="
				echo "Running command svn up..."
				a=0;a=`ls -1 $dirname/$D"_dev" | wc -l`	
				svn up $dirname/$D"_dev"
				b=0;a=`ls -1 $dirname/$D"_dev" | wc -l`	
				if [ $b -gt $a ];then
				   echo "A new DEVEL branch added to the directory."
				fi	
				
				a=0;a=`ls -1 $dirname/$D"_tags" | wc -l`	
				svn up $dirname/$D"_tag"
				b=0;a=`ls -1 $dirname/$D"_tags" | wc -l`
				if [ $b -gt $a ];then
				   echo "A new TAG branch added to the directory."
				fi
				echo ""	
				echo "Updated $D's contents"
  			  	continue 
			fi
			
			echo "=========================NEW PACKAGE Creating: $D ==================================="
			mkdir $dirname
			cd $dirname
		        REPO=${BSYS}"/packages/tags/"$D
		        svn co ${REPO} $D"_tags"
		        REPO=${BSYS}"/packages/devel/"$D
		        svn co ${REPO} $D"_dev"
			cd ..
			echo $dirname
			pkg_checker $dirname > $pkgInfoPath/$D"_pkginfo.txt"
		done	
	else
			#downloading tags and devel branches of a single package.	
			outdir=$2_`date +%F_%H.%M`"_ALL"
			if ! [ -d "$outdir" ];then
			  mkdir $outdir
			fi
			cd $outdir
		        dirname="$2_all"
                        mkdir $dirname
                        cd $dirname
                        REPO=${BSYS}"/packages/tags/"$2
                        svn co ${REPO} "$2_tags"
                        REPO=${BSYS}"/packages/devel/"$2
                        svn co ${REPO} "$2_dev"
                        cd ..
                        pkg_checker.sh $dirname > $dirname"/pkginfo.txt"
	fi
fi
