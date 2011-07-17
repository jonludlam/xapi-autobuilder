#!/bin/bash

# $1 = dir name
# $2 = repo name
# $3 = branch
# $4 = version
# $5 = dest

cd $1
git checkout $3
git archive --format tar --prefix=$2-$4/ $3 | gzip - > $5/$2_$4.orig.tar.gz
cd -
