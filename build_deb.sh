#!/bin/bash
set -e
set -x

usage() {
cat << EOF
Usage:
	$(basename $0) [-h] -p <package name> -v <upstream version>
		-g <git repo for debian dir> [-e <extra source tarball>]
		[-n new version]

	-p : Package name
	-v : Upstream version number
	-g : Git repository url for the debian directory
	-e : Extra source tarball to put into the src package
	-n : New version (will be passed to dch)
	-h : This help screen
}
EOF
}

while getopts "hp:v:g:e:n:" opt; do
  case $opt in
    h) usage; exit 0;;
    p) pkg="${OPTARG}";;
    v) version="${OPTARG}";;
    g) gitrepo="${OPTARG}";;
    e) extratarball="${OPTARG}";;
    *) echo "Invalid option"; usage ; exit 1 ;; 
  esac
done

mkdir -p tmp-build/${pkg}
cd tmp-build/${pkg}
cp ../../pristine/${pkg}_${version}.orig.tar.gz .
tar zxvf ${pkg}_${version}.orig.tar.gz
if [ ! -z ${extratarball} ]; then cp ../../pristine/${extratarball} .; fi
cd ${pkg}-${version}
if [ ! -z ${extratarball} ]; then tar zxvf ../${extratarball}; fi
git clone ${gitrepo} debian
currentver=`dpkg-parsechangelog | grep Version | cut -d\  -f2 | cut -d- -f1`
if [ ${currentver} != ${version} ]; then dch --newversion ${version}-1 "New autobuild version"; fi
mv debian/.git /tmp/${pkg}_debian_git
pdebuild --configfile ../../../pbuilderrc --use-pdebuild-internal
mv /tmp/${pkg}_debian_git debian/.git
cd ../../..


