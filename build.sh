#!/bin/bash

set -e

mkdir -p tmp-build
mkdir -p tmp-checkout

# Build xen

./mk_simple_git_archive.sh tmp-checkout/xen-debian debian/ master xen-debian.tar.gz $TOP/pristine 
./build_dsc.sh -p xen -v 4.1.1 -d $TOP/pristine/xen-debian.tar.gz -e xen_4.1.1.orig-qemu.tar.gz

build_gbp ()
{
pushd tmp-checkout/$1
git-buildpackage -S -uc -us --git-export-dir=../build-area
mv ../build-area/* $TOP/tmp-debs
popd
}

# Build userspace blktap
build_gbp blktap 
build_gbp xen-api-libs
build_gbp xen-api
#build_gbp vhdd
build_gbp xcp-storage-managers
build_gbp xcp-eliloader
build_gbp blktap-dkms
build_gbp xcp-guest-templates
build_gbp vncterm
