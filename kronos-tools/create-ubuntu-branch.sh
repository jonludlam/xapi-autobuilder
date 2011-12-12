#!/bin/bash

set -e
set -x

git checkout master
git fetch origin debian:debian
git branch -D ubuntu
git branch ubuntu debian
git checkout ubuntu

version=$(dpkg-parsechangelog -c1 -ldebian/changelog | grep Version | cut -f2 -d' ')
dch -v ${version}ubuntu1 "Ubuntu stamp" --distribution "oneiric precise" --force-distribution

git commit -a -s -m "Ubuntu stamp"
