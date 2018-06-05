#!/bin/bash
#
# Author: Bilal Hatipoglu
# Date:   Jan 7, 2013
#
#

BSYS_SVN=http://svn.corp.airties.com/svn

usage () {
	echo "Usage: svn_log_user [repository] [username] <days_back>"
}

if [ $# -lt 2 ]; then
	usage
	exit
fi

REPO=${BSYS_SVN}/$1
USER=$2

if [ x"$3" = x"" ]; then
	DAYS=7
else
	DAYS=$3
fi

DATE=`date  --date="$DAYS days ago" --rfc-3339=date`

echo "Listing commits on ${REPO} by ${USER} from ${DATE} to NOW:"

svn log  -v -r HEAD:\{${DATE}\} ${REPO} | sed -n "/${USER}/,/-----$/ p"


