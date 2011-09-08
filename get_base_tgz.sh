#!/bin/bash

if [ -e ${cache}/base.tgz ]; then
	cp ${cache}/base.tgz .
	sudo pbuilder --update --configfile pbuilderrc
fi

