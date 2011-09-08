#!/bin/bash
set -x

echo "From cache: attempting to retrieve $1"

if [ "x${cache}" = "x" ]; then
	cache=`cat cachelocation`
fi

latest=${cache}/latest

if [ -e ${latest}/$1 ]; then
	ln -s ${latest}/$1 .
fi

touch *.deb
apt-ftparchive packages . > Packages
sudo pbuilder --update --configfile ../pbuilderrc 

