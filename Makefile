

all : hooks/D05deps pbuilderrc pristine pristine/xen_4.1.1.orig.tar.gz pristine/xen_4.1.1.orig-qemu.tar.gz /var/cache/pbuilder/base.tgz
	./build.sh

clean : 
	./clean.sh

/var/cache/pbuilder/base.tgz : pbuilderrc tmp-debs
	sudo pbuilder --create --configfile pbuilderrc --debootstrap cdebootstrap --debootstrapopts "--keyring=/usr/share/keyrings/debian-archive-keyring.gpg"

tmp-debs :
	mkdir tmp-debs
	touch tmp-deb/Packages

hooks/D05deps: hooks/deps.in
	PWD=$(shell pwd)
	sed 's\@PWD@\$(PWD)\g' < hooks/deps.in > hooks/D05deps
	chmod 755 hooks/D05deps

pbuilderrc: pbuilderrc.in
	PWD=$(shell pwd)
	sed 's\@PWD@\$(PWD)\g' < pbuilderrc.in > pbuilderrc

pristine : 
	mkdir pristine

# Xen pristine stuff

pristine/xen_4.1.1.orig.tar.gz : 
	cp pristine-xen/xen_4.1.1.orig.tar.gz pristine

pristine/xen_4.1.1.orig-qemu.tar.gz :
	cp pristine-xen/xen_4.1.1.orig-qemu.tar.gz pristine


# To upload:

PHONY: install
install:
	mkdir -p debian
	mkdir -p debian/source
	cp tmp-debs/*.dsc tmp-debs/*.tar.gz tmp-debs/*.changes debian/source
	cp tmp-debs/*.deb debian
	rm debian/xen-utils*.deb ### This is currently broken!



