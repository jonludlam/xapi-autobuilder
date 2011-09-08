#!/bin/bash

if [ -e ${cache}/base.tgz ]; then
	cp ${cache}/base.tgz .
	sudo pbuilder --update --configfile pbuilderrc
else
        sudo pbuilder --create --configfile pbuilderrc --debootstrap cdebootstrap --debootstrapopts "--keyring=/usr/share/keyrings/debian-archive-keyring.gpg"
fi

