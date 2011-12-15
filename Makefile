.PHONY: source binary default fromcache tocache clean distclean build source-debs source-makefile

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

tmp-checkout/.stampfile : git-repos
	./checkout.sh
	touch $@

source-debs : hooks/D05deps tmp-checkout/.stampfile
	./build.sh

source-makefile : 
	./make_makefile.sh	
	./fix_dsc_timestamps.sh

source : 
	$(MAKE) source-debs
	$(MAKE) source-makefile

binary : hooks/D05deps
	./update_tmp_debs_packages.sh
	make -C tmp-debs

fromcache :
	make -C tmp-debs fromcache
	./update_tmp_debs_packages.sh
	./get_base_tgz.sh

tocache :
	make -C tmp-debs tocache

repo : 
	./mkrepo.sh

clean : 
	./clean.sh

distclean : clean
	rm -rf tmp-checkout
	rm -rf base.tgz

hooks/D05deps: hooks/deps.in
	PWD=$(shell pwd)
	sed 's\@PWD@\$(PWD)\g' < hooks/deps.in > hooks/D05deps
	chmod 755 hooks/D05deps

# To upload:

PHONY: install
install:
	mkdir -p debian
	mkdir -p debian/source
	cp tmp-debs/*.dsc tmp-debs/*.tar.gz debian/source
	cp tmp-debs/*.deb debian
	rm debian/xen-utils*.deb ### This is currently broken!



