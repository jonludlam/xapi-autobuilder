#!/bin/bash

mkdir -p tmp-checkout

pushd tmp-checkout

while read line; do
	repo=`echo $line | awk '{print $1}'`
	branch=`echo $line | awk '{print $2}'`
	dir=`basename $repo .git`
	git clone $repo
	pushd $dir
	git checkout $branch
	popd
done < ../git-repos

for i in `cat ../hg-repos`
do
	hg clone $i `basename $i .hg`
done

popd
