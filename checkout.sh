#!/bin/bash

mkdir -p tmp-checkout

pushd tmp-checkout

while read line; do
	git clone $line
done < ../git-repos

for i in `cat ../hg-repos`
do
	hg clone $i `basename $i .hg`
done

popd
