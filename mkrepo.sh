#!/bin/bash

TOP=`pwd`

cd tmp-debs
dpkg-sig --sign builder *.deb
cd $TOP/repo/apt/debian
reprepro includedeb unstable $TOP/tmp-debs/*.deb

