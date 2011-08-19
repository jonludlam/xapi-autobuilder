#!/bin/bash

TOP=`pwd`

cd tmp-debs
dpkg-sig --sign builder *.deb
cd $TOP/repo/apt/debian
reprepro includedeb unstable $TOP/tmp-debs/*.deb
wget http://downloads.xen.org/XCP/debian/blktap-dkms_0.1_all.deb
reprepro includedeb unstable blktap-dkms_0.1_all.deb
rm blktap-dkms_0.1_all.deb
