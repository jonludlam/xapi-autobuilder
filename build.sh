#!/bin/bash

TOP=`pwd`

mkdir tmp-build
mkdir tmp-checkout

# Build xen

./build_deb.sh xen 4.1.1 git://github.com/jonludlam/xen-debian.git xen_4.1.1.orig-qemu.tar.gz

# Build userspace blktap
git clone git://github.com/jonludlam/blktap.git tmp-checkout/blktap
./mk_git_archive.sh tmp-checkout/blktap blktap master 0.1 $TOP/pristine
./build_deb.sh blktap 0.1 git://github.com/jonludlam/blktap-debian.git 

# Xen-api-libs
git clone git://github.com/xen-org/xen-api-libs.git tmp-checkout/xen-api-libs
./mk_git_archive.sh tmp-checkout/xen-api-libs xen-api-libs master 0.1 $TOP/pristine
./build_deb.sh xen-api-libs 0.1 git://github.com/jonludlam/xen-api-libs-debian.git

# Xen-api
git clone git://github.com/xen-org/xen-api.git tmp-checkout/xen-api
./mk_git_archive.sh tmp-checkout/xen-api xen-api master 0.1 $TOP/pristine
./build_deb.sh xen-api 0.1 git://github.com/jonludlam/xen-api-debian.git

# Vhdd
git clone git://github.com/jonludlam/vhdd.git tmp-checkout/vhdd
./mk_git_archive.sh tmp-checkout/vhdd vhdd master 0.1 $TOP/pristine
./build_deb.sh vhdd 0.1 git://github.com/jonludlam/vhdd-debian.git

# Xen-sm
hg clone http://xenbits.xen.org/XCP/xen-sm.hg tmp-checkout/xen-sm.hg
./mk_hg_archive.sh tmp-checkout/xen-sm.hg xen-sm 0.1 $TOP/pristine
./build_deb.sh xen-sm 0.1 git://github.com/jonludlam/xen-sm-debian.git

# vncterm
hg clone http://hg/carbon/trunk/vncterm.hg tmp-checkout/vncterm.hg
./mk_hg_archive.sh tmp-checkout/vncterm.hg vncterm 0.1 $TOP/pristine
./build_deb.sh vncterm 0.1 git://github.com/jonludlam/vncterm-debian.git
