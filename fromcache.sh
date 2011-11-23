#!/bin/bash
set -x
set -e

echo "From cache: attempting to retrieve $1"

if [ ! "x${HTTPCACHE}" = "x" ]; then
	wget ${HTTPCACHE}/latest/${DIST}/${ARCH}/$1 || true
	exit 0
fi

if [ "x${cache}" = "x" ]; then
	cache=`cat cachelocation`
fi

latest=${cache}/latest

if [ -e ${latest}/$1 ]; then
	rsync -a ${latest}/$1 .
	echo $1 >> rsynced
fi



