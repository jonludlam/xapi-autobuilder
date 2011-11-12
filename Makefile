.PHONY: source binary default fromcache tocache clean distclean build base.tgz

TOP := $(shell pwd)
export TOP

DIST ?= sid
ARCH ?= i386

export DIST
export ARCH

default: build

build: 
	$(MAKE) source
	$(MAKE) fromcache
	$(MAKE) binary
	$(MAKE) tocache

tmp-checkout/.stampfile :
	./checkout.sh
	touch $@

source : hooks/D05deps pristine pristine/xen_4.1.1.orig.tar.gz pristine/xen_4.1.1.orig-qemu.tar.gz base.tgz tmp-checkout/.stampfile
	./build.sh
	./make_makefile.sh	
	./fix_dsc_timestamps.sh

binary :
	make -C tmp-debs

fromcache :
	make -C tmp-debs fromcache
	apt-ftparchive packages tmp-debs > tmp-debs/Packages
	sudo -E cowbuilder --update --configfile pbuilderrc2


tocache :
	make -C tmp-debs tocache

repo : 
	./mkrepo.sh

clean : 
	./clean.sh

distclean : clean
	rm -rf tmp-checkout
	rm -rf base.tgz

base.tgz : tmp-debs/.stampfile
	./get_base_tgz.sh

tmp-debs/.stampfile :
	mkdir -p tmp-debs
	touch tmp-debs/Packages
	touch $@

hooks/D05deps: hooks/deps.in
	PWD=$(shell pwd)
	sed 's\@PWD@\$(PWD)\g' < hooks/deps.in > hooks/D05deps
	chmod 755 hooks/D05deps

pristine : 
	mkdir -p pristine

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
	cp tmp-debs/*.dsc tmp-debs/*.tar.gz debian/source
	cp tmp-debs/*.deb debian
	rm debian/xen-utils*.deb ### This is currently broken!



