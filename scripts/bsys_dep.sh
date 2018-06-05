#!/bin/bash

BSYS_LOCAL=/home/noe287/Development/projects/newbuild
BSYS_SVN=http://svn.corp.airties.com/svn/atlantis/buildsys

PROFILE=$1

mk_checkout() {
#        echo "[+] preparing environment"
        svn co ${BSYS_SVN} ${BSYS_LOCAL} &>/dev/null
        cat << EOF > ${BSYS_LOCAL}/svn
#!/bin/sh
echo "\$@" | sed -e "s/.*\(http:\/\/.*\)@.*/URL=\1/"
EOF
chmod +x ${BSYS_LOCAL}/svn
}


mk_profile() {
#        echo "[+] updating profile"
        ( cd ${BSYS_LOCAL} && . ./environment && echo | make ${PROFILE} &>/dev/null)
}


list_svn() {
#        echo "[+] listing resources"
        ( cd ${BSYS_LOCAL} && . ./environment && PATH=${BSYS_LOCAL}:${PATH} make co -j8 2>/dev/null | sed -ne "s/^URL=//p" )
        echo ${BSYS_SVN}/configs/${PROFILE}.config
}

list_packages(){
	#echo "[+] Listing Packages"
	cat ${BSYS_LOCAL}/configs/${PROFILE}.config  | grep 'CONFIG_.*_PATH="' | grep -o '\".*\"' | grep -o '\w.*\w'
}

if [ x"$PROFILE" = x"" ]; then
  echo "Usage: bsys_dep.sh [profile]"
  exit
fi

mk_checkout
mk_profile
#list_svn
list_packages


