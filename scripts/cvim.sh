FOLDERCNT=`ls | xargs file | grep directory | wc -l`
set -x #for script debugging

DIR=$PWD
FILTER="$PWD/filter.sh"
CSCOPE_FILES="$PWD/cscope/cscope.files"
relevantDirs=(manager air-cdf awf-ng air-bus air-cloud-agent air-wall wireless wireless_tools wireless-controller hostapd wpa_supplicant metrics automesh air_eoe airwpa airlibs statistics-collector air-rm filesystem_platform mesh-wal metrics-ng air-mal)

function __process_cscope() {
# The -b flag tells Cscope to just build the database, and not launch the Cscope GUI. 
# The -q causes an additional, 'inverted index' file to be created, which makes searches run much faster for large databases.
# Finally, -k sets Cscope's 'kernel' mode--it will not look in /usr/include for any header files that are #included in your
# source files (this is mainly useful when you are using Cscope with operating system and/or C library source code, as we are here).
	cd $DIR/cscope/	
	if [ ! -e "$DIR/csope/cscope.out" ]
	then
		cscope -b -q > /dev/null
		#cscope -R
		#cscope -d
	fi
	cd $DIR
	# if [ ! -e "tags" ]
	# then
	# 	ctags -R > /dev/null
	# fi
}

function __cscope() {
	
	local skip_dir=0

	# Prepare "find" file to select "dirs" in "relevantdirs"
	echo "find $PWD \\" >> $FILTER
	echo "-path \"$PWD/.git/*\" -prune -o \\" >> $FILTER
	for file in `ls`;
	do
		if [ "$1" == "0" ]
		then
			break
		fi

		skip_dir=0
		for rfile in ${relevantDirs[*]}
		do
			if [ "$file" == "$rfile" ]
			then
				skip_dir=1
				break	
			fi
		done
		
		if [ "$skip_dir" == "0" ]
		then
			echo "-path \"$PWD/$file/*\" -prune -o \\" >> $FILTER
		fi
	done
	
	echo "-name \"*.[chxsS]\" -print" >> $FILTER

	#create "find" file
	chmod +x ./filter.sh
	./filter.sh > $CSCOPE_FILES
	rm $FILTER

	#Build db
	__process_cscope
}

function init() {

	if [ "$1" == "del" ]
	then
		rm -rf $PWD/cscope/*
		rm -rf $PWD/cscope 
		rm -rf $PWD/filter.sh
	fi

	if [ ! -d "$PWD/cscope" ]
	then
		mkdir $PWD/cscope
	fi

	if [ "$FOLDERCNT" -ge 250 ]  # Number of folders in buildsys is 256 
	then
		__cscope             # Huge cscope db to be created for buildsys folder
	else 
		__cscope "0"         # Create a db only for the current folder; presumably not buildsys.
	fi  
}

init $1   
vim
