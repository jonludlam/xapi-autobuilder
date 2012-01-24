#!/bin/bash

set -e

mkdir -p $TOP/build $TOP/$DIST-$ARCH $TOP/$DIST-$ARCH/aptcache

if [ -e $TOP/$DIST-$ARCH/base.cow/etc/apt/sources.list ]; then
	sudo -E cowbuilder --update --configfile pbuilderrc2
else
        sudo mkdir -p /var/cache/pbuilder/$DIST-$ARCH/base.cow
        sudo -E cowbuilder --create --configfile pbuilderrc2
	sudo -E cat <<EOF > /tmp/script.sh
#!/bin/bash
apt-get install -y apt-utils
EOF
	sudo -E cowbuilder --execute --configfile pbuilderrc2 --save-after-exec -- /tmp/script.sh
fi

