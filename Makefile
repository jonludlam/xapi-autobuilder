.PHONY: source binary default fromcache tocache
default: source

tmp-checkout/.stampfile :
	./checkout.sh
	touch $@

source : hooks/D05deps pbuilderrc pristine pristine/xen_4.1.1.orig.tar.gz pristine/xen_4.1.1.orig-qemu.tar.gz base.tgz tmp-checkout/.stampfile
	./build.sh
	./make_makefile.sh	

binary : 
	make -C tmp-debs

fromcache :
	make -C tmp-debs fromcache
	touch tmp-debs/*.deb
	apt-ftparchive packages tmp-debs > tmp-debs/Packages
	sudo pbuilder --update --configfile pbuilderrc


tocache :
	make -C tmp-debs tocache

repo : 
	./mkrepo.sh

clean : 
	./clean.sh

base.tgz : pbuilderrc tmp-debs/.stampfile
	./get_base_tgz.sh
	./stash_base_tgz.sh

tmp-debs/.stampfile :
	mkdir -p tmp-debs
	touch tmp-debs/Packages
	touch $@

hooks/D05deps: hooks/deps.in
	PWD=$(shell pwd)
	sed 's\@PWD@\$(PWD)\g' < hooks/deps.in > hooks/D05deps
	chmod 755 hooks/D05deps

pbuilderrc: pbuilderrc.in
	PWD=$(shell pwd)
	sed 's\@PWD@\$(PWD)\g' < pbuilderrc.in | sed 's\@cache@\$(cache)\' > pbuilderrc

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



