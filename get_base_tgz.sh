#!/bin/bash

if [ -e $TOP/$DIST-$ARCH/base.cow ]; then
	sudo -E cowbuilder --update --configfile pbuilderrc2
else
        sudo mkdir -p /var/cache/pbuilder/$DIST-$ARCH/base.cow
        sudo -E cowbuilder --create --configfile pbuilderrc2
	sudo -E cowbuilder --execute --configfile pbuilderrc2 --save-after-exec -- /usr/bin/apt-get install apt-utils
fi

