#!/bin/bash

pushd $1
if [ -e .hg ]; then
	hg archive -t tgz --prefix $2-$4/ $5/$2_$4.orig.tar.gz
elif [ -e .git ]; then
	git archive --format tar --prefix=$2-$4/ $3 | gzip - > $5/$2_$4.orig.tar.gz
else
	echo "No git/mercurial repo here!"
	popd
	exit 1
fi

