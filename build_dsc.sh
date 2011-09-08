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
	-d : debian directory tarball
	-e : Extra source tarball to put into the src package
	-n : New version (will be passed to dch)
	-h : This help screen
}
EOF
}

while getopts "hp:v:d:e:n:" opt; do
  case $opt in
    h) usage; exit 0;;
    p) pkg="${OPTARG}";;
    v) version="${OPTARG}";;
    d) debtarball="${OPTARG}";;
    e) extratarball="${OPTARG}";;
    *) echo "Invalid option"; usage ; exit 1 ;; 
  esac
done

rm -rf tmp-build/${pkg}
mkdir -p tmp-build/${pkg}
cd tmp-build/${pkg}
cp ../../pristine/${pkg}_${version}.orig.tar.gz .
tar zxvf ${pkg}_${version}.orig.tar.gz
if [ ! -z ${extratarball} ]; then cp ../../pristine/${extratarball} .; fi
cd ${pkg}-${version}
if [ ! -z ${extratarball} ]; then tar zxvf ../${extratarball}; fi
tar zxvf ${debtarball}
currentver=`dpkg-parsechangelog | grep Version | cut -d\  -f2 | cut -d- -f1`
if [ ${currentver} != ${version} ]; then dch --newversion ${version}-1 "New autobuild version"; fi
debuild -S -us -uc
cd ..
cp *.dsc *.gz ../../tmp-debs/ 
cd ../../..


