#!/bin/bash



GIT_SERVER=git.corp.airties.com                                                                                                                            
REFERENCES_PATH=$(git config --global references.path)
DOMAIN_USER_NAME=$(git config --global --get user.email | sed 's/\(.*\)@.*/\1/')

echo $REFERENCES_PATH
#DATE=`date %M_%H_%F`
DATE=`date +%d_%m_%y-%H.%M.%S`
REPOSITORY=buildsys

if [ ! $1 ]
then
    DESTINATION_PATH=$DATE"_"$REPOSITORY
else
    DESTINATION_PATH=$DATE"_"$1
fi

if [ ! -z $REFERENCES_PATH ]
then
  if [ -d $REFERENCES_PATH/$REPOSITORY.git ]
  then
    git --git-dir=$REFERENCES_PATH/$REPOSITORY.git fetch
  else
    git clone --mirror git://git.corp.airties.com/$REPOSITORY $REFERENCES_PATH/$REPOSITORY.git
  fi
  REFERENCES_PARAM="--reference $REFERENCES_PATH/$REPOSITORY.git"
fi

git clone $REFERENCES_PARAM git://git.corp.airties.com/$REPOSITORY $DESTINATION_PATH

if [ ! $2 ]
then
    echo "If you want to crate a custom profile based buildsys environment type the command as below:"
    echo " airgitclone.sh PROFILENAME (bl || co) [y] "
    exit
fi

[ -z $DOMAIN_USER_NAME ] || git --git-dir=$DESTINATION_PATH/.git remote set-url --push origin ssh://$DOMAIN_USER_NAME@$GIT_SERVER:29418/$REPOSITORY


# if [ $2 ]
# then
#   MODE="bl"
# else
#   MODE="co"
# fi

mode=$2

cd $DESTINATION_PATH
source environment
if [ ! $3 ]
then
    echo "Profiles package used..."
    bake $1 USE_PROFILES_PACKAGE=y        
else
    bake $1        
    echo "No profiles package used..."
fi

bake menuconfig
bake co -j3

if [ "$mode" == "bl" ]; then
	echo "MODE build"
	bake modem
else
	echo "MODE checkout"
fi



# else 
# 	echo "MODE co"
#     cd $DESTINATION_PATH
# 	source environment
# 	bake menuconfig
# 	bake $1 USE_PROFILES_PACKAGE=y        
#     bake co -j3
# fi
