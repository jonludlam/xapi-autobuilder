#!/bin/bash

set -e
set -x

# If ubuntu branch exists, check it out and use it, as it's being managed
# manually. Otherwise, create the ubuntu branch from the debian branch.

git checkout master
git fetch origin debian:debian

# Does ubuntu branch exist? Check it out and exit.
if [ `git branch | grep "ubuntu$"` ]; then
	git checkout ubuntu
	exit 0
fi

# Ubuntu branch doesn't exist. Create it from debian and bump changelog.
git branch ubuntu debian
git checkout ubuntu

version=$(dpkg-parsechangelog -c1 -ldebian/changelog | grep Version | cut -f2 -d' ')
dch -v ${version}ubuntu1 "Ubuntu stamp" --distribution "oneiric precise" --force-distribution
