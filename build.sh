#!/bin/bash

set -e

BUILDTIME=`date +'%s'`
STDVER=0.1+${BUILDTIME}
mkdir -p tmp-build
mkdir -p tmp-checkout

max2 ()
{
  if [ "$1" -gt "$2" ]
  then
    echo $1
  else
    echo $2
  fi
}

maxtimestamp ()
{
  t1=`./get_date.sh $1`
  t2=`./get_date.sh $2`
  t3=$(max2 $t1 $t2)
  echo $t3 
}

# Build xen

./mk_simple_git_archive.sh tmp-checkout/xen-debian debian/ master xen-debian.tar.gz $TOP/pristine 
./build_dsc.sh -p xen -v 4.1.1 -d $TOP/pristine/xen-debian.tar.gz -e xen_4.1.1.orig-qemu.tar.gz

build_dsc ()
{
TIMESTAMP=$(maxtimestamp tmp-checkout/$1 tmp-checkout/$2)
./mk_archive.sh tmp-checkout/$1 $1 HEAD ${3}+${TIMESTAMP} $TOP/pristine
./mk_simple_git_archive.sh tmp-checkout/$2 debian/ HEAD $2.tar.gz $TOP/pristine
./build_dsc.sh -p $1 -v ${3}+${TIMESTAMP} -d $TOP/pristine/$2.tar.gz
}

build_gbp ()
{
pushd tmp-checkout/$1
git-buildpackage -S -uc -us --git-export-dir=../build-area
mv ../build-area/* $TOP/tmp-debs
popd
}

# Build userspace blktap
build_dsc blktap blktap-debian 2.0.90
build_gbp xen-api-libs
build_dsc xen-api xen-api-debian 0.1
build_dsc vhdd vhdd-debian 0.1
build_dsc xen-sm xen-sm-debian 0.1
build_gbp xcp-eliloader
build_gbp blktap-dkms
build_gbp xcp-guest-templates

# Optional, since source isn't published yet
build_dsc vncterm vncterm-debian 0.1 || true
