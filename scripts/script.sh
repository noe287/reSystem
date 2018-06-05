#ex: script.sh /home/noe287/work_space/projects/PROFILES/Air5650TT_2014-01-30_17.17/tools/fosstools/foss_metadata/*atmctl-4.12L.04.metadata* atmctl-4.12L.04/metadata



files="$1"
target_name=`basename $PWD`
dirname_branch=`dirname $2`
metadata=\$"$#"

metadata=$(eval echo ${metadata})
#echo "METADATA:" $metadata

for f in $files;do
	filename=`basename $f`
	dirname=`dirname $f`


	echo "HELLO WORLD" $filename $dirname
	
	if [ "$target_name" = "bootloader" ];then
		for i in `ls`;do if [ -d $i ];then echo $i;break;fi;done
		if [ "$i" = "u-boot-air-binaries" ];then
		   cp $dirname/$filename u-boot-air-binaries/metadata
		else
		   cp $dirname/$filename $metadata
		fi
		#continue
		break
	fi
	
	echo $filename
	echo "cp $dirname/$filename $metadata"
	cp $dirname/$filename $metadata
exit
done




