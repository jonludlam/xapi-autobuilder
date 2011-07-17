#!/bin/bash
set -x

# $1 = dir name
# $2 = repo name
# $3 = version
# $4 = dest

cd $1
hg archive -t tgz --prefix $2-$3/ $4/$2_$3.orig.tar.gz
cd -
