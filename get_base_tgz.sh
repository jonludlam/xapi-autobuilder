#!/bin/bash

if [ -e /var/cache/pbuilder/$DIST-$ARCH-base.tgz ]; then
	sudo -E pbuilder --update --configfile pbuilderrc2
else
        sudo -E pbuilder --create --configfile pbuilderrc2
fi

