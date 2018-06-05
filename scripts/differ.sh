PATCH_DIR="/home/nejat/Development/projects/ZELSE/patches/"
DALEK_PATCH_DIR="/home/nejatonay.erkose/patches"
TO_DALEK="nejatonay.erkose@dalek:/home/nejatonay.erkose/patches/"

function usage() {
	echo "Wrong usage exiting..."
	echo "Usage: differ.sh [s|g] patchname"
	printf "Find all the patches in $PATCH_DIR or \nOn DALEK server: $TO_DALEK\n"
	exit
}


if [ ! $1 ]
then
	usage
fi

#filename=$1_`date +%F_%H_%M`.diff
dir=`pwd`
base=`basename $dir`
echo "Extracting profile name:"
profile_name=`pwd | cut -d "/" -f7 | cut -d "_" -f1`
echo "$profile_name"
echo "Preparing diff name:"
file=$2_`date +%F_%H_%M`.patch
filename=$profile_name"_"$base"_"$file
echo "$filename"

if [ "$1" = "s" ]
then
	svn diff > $filename

elif [ "$1" = "g" ]
then
	git diff > $filename

else
	usage
	exit
fi




echo "Copying $filename  to $PATCH_DIR ..."
cp $filename $PATCH_DIR
echo "Uploading $filename to  dalek $DALEK_PATCH_DIR ..."
scp $filename $TO_DALEK
