#!/bin/bash

set -e

if ! [ -d tmp-checkout ]; then
	echo "checkout repos first"
	exit 1
fi

pushd tmp-checkout

while read line; do
	repo=`echo $line | awk '{print $1}'`
	branch=`echo $line | awk '{print $2}'`
	dir=`basename $repo .git`

	if [ ${dir} != "xen" ]; then
		pushd ${dir}

		git checkout ${branch}
		git pull origin ${branch}

		version=$(dpkg-parsechangelog -c1 -ldebian/changelog | grep Version | cut -f2 -d' ')
		major=$(echo ${version} | cut -d- -f1)
		minor=$(echo ${version} | cut -d- -f2)
		newversion=$major-$(expr ${minor} + 1)

		dch -v ${newversion} "xapi-autobuilder automatic changelog bump" --distribution "unstable" --force-distribution
		git commit -a -m "xapi-autobuilder: bump changelog"
		git push origin ${branch}

		popd
	fi
done < ../git-repos

popd
