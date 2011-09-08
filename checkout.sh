#!/bin/bash

mkdir -p tmp-checkout

pushd tmp-checkout

for i in `cat ../git-repos`
do
	git clone $i
done

for i in `cat ../hg-repos`
do
	hg clone $i `basename $i .hg`
done

popd
