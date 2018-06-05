#!/bin/bash

GIT_SERVER=git.corp.airties.com                                                                                                                            
REFERENCES_PATH=$(git config --global references.path)
DOMAIN_USER_NAME=$(git config --global --get user.email | sed 's/\(.*\)@.*/\1/')

echo $REFERENCES_PATH
#DATE=`date +%F_%H.%M`
DATE=`date +%d_%m_%y-%H.%M.%S`
REPOSITORY=buildsys
DESTINATION_PATH=$DATE"_"$1


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
exit
fi


[ -z $DOMAIN_USER_NAME ] || git --git-dir=$DESTINATION_PATH/.git remote set-url --push origin ssh://$DOMAIN_USER_NAME@$GIT_SERVER:29418/$REPOSITORY

if [ $2 ]
then
  MODE="bl"
else
  MODE="co"
fi

if [ "$MODE" == "bl" ]
then
	echo "MODE bl"
	cd $DESTINATION_PATH
	source environment
	make $1 USE_PROFILES_PACKAGE=y        
	make co -j3
	make modem
else 
	echo "MODE co"
	cd $DESTINATION_PATH
	source environment
	make menuconfig
	make $1 USE_PROFILES_PACKAGE=y        
    make co -j3
fi
