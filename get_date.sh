#!/bin/bash

set -e

pushd $1 > /dev/null

if [ -e .git ]; then
	git show --format=format:%at | head -n 1
elif [ -e .hg ]; then
	hg log --template '{date}\n' | cut -d. -f1 | head -n 1
else
	echo "No git/mercurial repo here!"
	exit 1
fi

