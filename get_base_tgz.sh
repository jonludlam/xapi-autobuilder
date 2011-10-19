#!/bin/bash

if [ -e ${cache}/base.tgz ]; then
	cp ${cache}/base.tgz .
	sudo -E pbuilder --update --configfile pbuilderrc2
else
        sudo -E pbuilder --create --configfile pbuilderrc2 --debootstrap cdebootstrap --debootstrapopts "--keyring=/usr/share/keyrings/debian-archive-keyring.gpg"
fi

