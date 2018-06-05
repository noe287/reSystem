if [ ! $1 ];then
 exit
fi 

IN=$PWD
array=(${IN//// })

#arr_len=`echo ${#array[@]}`
#echo $arr_len

for i in "${!array[@]}"
do
echo $i
#	echo "$i=>${array[$i]}"
	test=${array[$i]}
	if [ "$flag" = 1 ]
	then
		if echo $test | grep "Air"; then
			continue
		fi

		remote_path+="$test/"
	fi

	if [ "$test" = "projects" ]
	then
		flag=1
	fi
done

echo $remote_path

remote_cmd="/home/noe287/Development/projects/$1/$remote_path"
prj_name=$1
ssh_login="noe287@10.20.0.114"
echo "Diffing the file at location $ssh_login:/home/noe287/Development/projects/$1/$remote_path"

#ssh noe287@10.20.0.114 'svn diff' /home/noe287/Development/projects/$prj_name/$remote_path
ssh $ssh_login 'cd' "$remote_cmd" ';svn diff' > patch.diff
echo "Patch is saved in $PWD/patch.diff"

echo "Do you want to apply a dry run on the patch?[n]"
read user_input
if [ "$user_input" = "y" ]
then
  echo "Patching files"
  patch -p0 --dry-run < patch.diff
  echo "Do you want to continue with patching the files?[n]"
  read user_input
  if [ "$user_input" = "y" ]
  then
  	echo "Patching files"
	patch -p0 < patch.diff
  else
	exit
  fi
elif [[ "$user_input" = "n" ]] || [[ "$user_input" = " " ]]
then
  echo "Do you want to run patch directly or just dont do anything?[n]"
  read user_input
  if [ "$user_input" = "y" ]
  then
  	echo "Patching files"
	patch -p0 < patch.diff
  else
	echo "patch.diff remains in $PWD,no changes have been made on the source files..."
	exit

  fi
fi

#ssh noe287@10.20.0.114 'svn diff /home/noe287/Development/projects/Air4641_awfng_2013-09-09_12.11/awf-ng/awf-ng-1.1-devel'














#arr=`echo $IN | tr "/" "\n"`

#for i in $(echo $IN | tr "/" "\n")
#do
#	echo $i
#	echo " " 

#done
