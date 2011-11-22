#!/bin/bash
set -x

echo "From cache: attempting to retrieve $1"

if [ "x${cache}" = "x" ]; then
	cache=`cat cachelocation`
fi

latest=${cache}/latest

if [ -e ${latest}/$1 ]; then
	rsync -a ${latest}/$1 .
	echo $1 >> rsynced
fi



