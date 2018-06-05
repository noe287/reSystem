alias dalekmount='sshfs nejatonay.erkose@dalek:/home/nejatonay.erkose/ ~/Dalek'
alias taryap='tar -cjf'
alias tarac='tar -xvf'
alias eco='rdesktop -g 1280x1024 -r disk:share=/home/noe/tmpECO -r clipboard:CLIPBOARD -u nejatonay.erkose -d AIRTIES terminal2.corp.airties.com'
alias mounthq='sudo mount.cifs  //hq-storage/HQUserFiles/UserFiles hqs -o user="AIRTIES\nejatonay.erkose"'

function fwwrite()
{
	/usr/bin/fw_write $1 $2
}

function cobs()
{
	number=0
	filename=$(date +"%d_%m_%Y")
	while(true); do
		if [ -d ${filename} ]; then
			if [ ${number} == "0" ]; then
				let "number += 1"
			fi
			if [ -d ${filename}_${number} ]; then
				let "number += 1"
				continue
			fi
			break
		else
			break
 		fi
 	done
 
	if [ ${number} != "0" ]; then
		echo
		echo `tput setaf 4``tput bold`"Filename: " `tput setaf 3`${filename}"_"`tput setaf 1`${number}`tput sgr0`
		echo
		bekirgitclone buildsys ${filename}_${number}
		cd ${filename}_${number}
	else
		echo
		echo `tput setaf 4``tput bold`"Filename: "`tput setaf 3` ${filename}`tput sgr0`
		echo
		bekirgitclone buildsys ${filename}
		cd ${filename}
	fi

	echo
	echo `tput setaf 1``tput bold`"Exporting Environment Variables"
	source environment
	echo `tput setaf 2`"Environment Variables are exported"`tput sgr0`
	echo

	USE_PROFILES_PACKAGE=y bake Air$1
	echo
	echo `tput bold``tput setaf 2`"Air"$1" config has successfully been written"`tput sgr0`
	echo
}

function cobso()
{
	number=0
	filename=$(date +"%d_%m_%Y")
	while(true); do
		if [ -d ${filename} ]; then
			if [ ${number} == "0" ]; then
				let "number += 1"
			fi
			if [ -d ${filename}_${number} ]; then
				let "number += 1"
				continue
			fi
			break
		else
			break
 		fi
 	done
 
	if [ ${number} != "0" ]; then
		echo
		echo `tput setaf 4``tput bold`"Filename: " `tput setaf 3`${filename}"_"`tput setaf 1`${number}`tput sgr0`
		echo
		airgitclone buildsys ${filename}_${number}
		cd ${filename}_${number}
	else
		echo
		echo `tput setaf 4``tput bold`"Filename: "`tput setaf 3` ${filename}`tput sgr0`
		echo
		airgitclone buildsys ${filename}
		cd ${filename}
	fi

	echo
	echo `tput setaf 1``tput bold`"Exporting Environment Variables"
	source environment
	echo `tput setaf 2`"Environment Variables are exported"`tput sgr0`
	echo
}

function svnco_pd()
{
	svn co http://svn.corp.airties.com/svn/atlantis/packages/devel/$1 $1
}

function svnco_pt()
{
	svn co http://svn.corp.airties.com/svn/atlantis/packages/tag/$1 $1
}

function gitco()
{
	git clone git://git.corp.airties.com/$1 $1
}

export SVN_EDITOR=vim 
