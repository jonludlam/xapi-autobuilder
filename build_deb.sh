#!/bin/bash

# $1=pkg 
# $2=version
# $3=git repository for debian packaging files

mkdir -p tmp-build/$1
cd tmp-build/$1
cp ../../pristine/$1_$2.orig.tar.gz .
tar zxvf $1_$2.orig.tar.gz
if [ ! -z $4 ]; then cp ../../pristine/$4 .; fi
cd $1-$2
if [ ! -z $4 ]; then tar zxvf ../$4; fi
git clone $3 debian
pdebuild --configfile ../../../pbuilderrc --use-pdebuild-internal
cd ../../..


