#echo manager-1.24-vdsl_retail-from_manager_1_24_vdsl_r39754_fon.metadata_dev[594 | grep -o '.*\.'

if [ ! -d depsdir ]
then
	mkdir depsdir
fi

while read i
do

metadatafilename="$i"

	while read line
	do
		shortname=`echo $metadatafilename | grep -o ".*\."`
	
		echo "$shortname ?= $line."

		if [ "$shortname" = "$line." ]
		then
			echo "$shortname == $line."
			cp $metadatafilename depsdir/$shortname"metadata"
		fi	

	done < newlistelements.txt

done < listmetadata.txt
