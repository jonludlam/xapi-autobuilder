#!/bin/bash
set -x
set -e

echo "To cache: attempting to cache $1"

if [ ! -e $1 ]; then
	echo "$1 doesn't exist. Exiting"
	exit 0
fi

if [ "x${cache}" = "x" ]; then
	echo "No cache set. Exiting"
	exit 0
fi

if [ "x$BUILD_NUMBER" = 'x' ]; then
	echo "No build number - not caching"
	exit 0
fi

thiscache=${cache}/${BUILD_NUMBER}

mkdir -p ${thiscache}

isrsynced=`grep $1 rsynced || true`

if [ ! "x$isrsynced" = "x" ]; then
	ln ${cache}/latest/$1 ${thiscache}/$1 
else
	cp --preserve $1 ${thiscache}/$1
fi






