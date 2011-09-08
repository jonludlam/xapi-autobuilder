#!/bin/bash

# $1 = dir name
# $2 = prefix
# $3 = branch
# $4 = tarball name
# $5 = dest

cd $1
git checkout $3
git archive --format tar --prefix=$2 $3 | gzip - > $5/$4
cd -
