#!/bin/bash
set -x

echo "To cache: attempting to cache $1"

if [ ! -e $1 ]; then
	echo "$1 doesn't exist. Exiting"
	exit 0
fi

if [ "x${cache}" = "x" ]; then
        cache=`cat cachelocation`
fi

if [ "x$BUILD_NUMBER" = 'x' ]; then
	echo "No build number - not caching"
	exit 0
fi

thiscache=${cache}/${BUILD_NUMBER}

mkdir -p ${thiscache}


linkloc=`readlink $1`
if [ $? = 0 ]; then
	ln $linkloc ${thiscache}/$1 
else
	cp $1 ${thiscache}/$1
fi






