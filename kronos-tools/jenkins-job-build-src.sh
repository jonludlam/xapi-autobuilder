#!/bin/bash

set -e
set -x

PROJECT_NAME=$(dirname ${JOB_NAME})

git checkout ${DIST}
git pull origin ${DIST}

DIR=`mktemp -d`

git-buildpackage -S -uc -us --git-debian-branch=${DIST} --git-export-dir=${DIR}

mkdir -p /shared/kronos/src/${DIST}/${PROJECT_NAME}/${BUILD_NUMBER}
cp ${DIR}/* /shared/kronos/src/${DIST}/${PROJECT_NAME}/${BUILD_NUMBER}

rm -f /shared/kronos/src/${DIST}/${PROJECT_NAME}/latest
ln -s ${BUILD_NUMBER} /shared/kronos/src/${DIST}/${PROJECT_NAME}/latest
rm -rf ${DIR}
