# This script finds the used packages in a profile and looks for Copyright, readme and  Copying files in its folders to determine the license of that package.
# This preliminary way to find licenses may or may not result with finding one, however. Therefore one may need to manually look into the code itself to see any notice of
# license or copyright information.

CHECKDIRS=`release/revision . .config | sed -ne 's/^.*]\(.*\)(.*/\1/p'`
IGNOREDIRS="filesystem_platform filesystem_product filesystem_base buildsys kernel release"

k=0
for f in $CHECKDIRS;do
	echo $IGNOREDIRS | grep $f > /dev/null
	if [ "$?" = "1" ];then
		echo "==================================================================$f =========================================================================="
#		grep -rni COPYING $f --exclude-dir={.svn,.git} 
#		grep -rni COPYRIGHT $f --exclude-dir={.svn,.git} 
#		grep -rni COPYING $f --exclude-dir={.svn,.git} 
		for i in `find $f -type d -name .svn -prune -o -name License* -o -name LICENSE* -o -name COPY* -o -name COPYRIGHT* -o -name README* -o -name readme* -type f | grep -vi .svn`;do
		        k=$(( $k + 1 ))
			mkdir -p license_dir/$f
			echo $i
			cp ${BSPROOT}/$i license_dir/$f/`basename $i`.$k 2>/dev/null	
		done
	else
		continue
	fi
done






