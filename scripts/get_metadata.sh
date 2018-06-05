
files="$1"
target_name=`basename $PWD`
dirname_branch=`dirname $2`
metadata=$2

for f in $files;do
	filename=`basename $f`
	dirname=`dirname $f`
	
	if [ "$target_name" = "bootloader" ];then
		for i in `ls`;do if [ -d $i ];then echo $i;break;fi;done
		if [ "$i" = "u-boot-air-binaries" ];then
		   cp $dirname/$filename u-boot-air-binaries/metadata
		else
		   cp $dirname/$filename $metadata
		fi
		continue
	fi
	echo $filename
	cp $dirname/$filename $metadata
exit
done




