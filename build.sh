#!/bin/bash

set -e

mkdir -p tmp-build
mkdir -p tmp-checkout
mkdir -p tmp-debs

build_gbp ()
{
pushd tmp-checkout/$1
git-buildpackage -S -uc -us --git-export-dir=../build-area
mv ../build-area/* $TOP/tmp-debs
popd
}

build_gbp xen
build_gbp xen-api-libs
build_gbp xen-api
#build_gbp vhdd
build_gbp xcp-storage-managers
build_gbp xcp-eliloader
build_gbp xcp-guest-templates
build_gbp vncterm

if [ $DIST != "sid" ]; then
	build_gbp blktap
	build_gbp blktap-dkms
fi

