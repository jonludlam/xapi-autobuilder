set -e

#/shared/kronos/src/$DIST/$JOB_NAME/latest

cd /shared/kronos/src/ubuntu/$(basename ${JOB_NAME} -ppa)/latest/
dpkg-sig -k D9015B85 --sign builder --sign-changes full *.changes
dput xcp-ppa-unstable *.changes
