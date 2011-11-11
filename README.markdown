## XenAPI Toolstack Autobuilder

Xen API (or xapi) is a management stack that configures and controls
Xen-enabled hosts and resource pools, and co-ordinates resources within the
pool.  Xapi exposes the Xen API interface for many languages and is a component
of the Xen Cloud Platform (XCP) project.  Xen API is written mostly in
[Ocaml](http://caml.inria.fr/ocaml/) 3.12.0.

This repository serves as an autobuilder for xapi and all of it's dependencies,
to include the Xen hypervisor itself. This is meant to be part of a continuous
integrationprocess, though it is also useful for buildling a personal set of
Debian packages yourself. To do this, just type 'make'. The makefile will clone
the appropriate repositories and use pbuilder to build Debian packages.

## Requirements

* Debian Sid (only i386 is supported at the moment, but we're working on amd64)
* debootstrap
* cdebootstrap
* pbuilder
* dh-ocaml
* dh-autoreconf

... and possibly more. Let us know if anything breaks due to missing
requirements or dependencies!

## Building and installing

Using this repository is as simple as cloning and making:

```
git clone https://github.com/jonludlam/xapi-autobuilder.git
cd xapi-autobuilder
make clean ; make
```

This will build all of the required packages for Xapi on Debian (except for
vncterm, which is only available as a binary until we sort out licensing
issues). Take a look at xapi-autobuilder/build.sh to see what's going on
inside, and modify that script to point to your own repositories if you plan on
compiling your own code.

Before installing the built Debian packages, you will
need to install blktap-dkms from xen.org:

```
wget http://downloads.xen.org/XCP/debian/blktap-dkms_0.1_all.deb
dpkg -i blktap-dkms_0.1_all.deb
```

Now you can install the finished packages:

```
cd tmp-debs
# only install the amd64 xen hypervisor
mv xen-hypervisor-4.1-i386_*_i386.deb xen-hypervisor-4.1-i386.deb_
dpkg -i *.deb
```

Now reboot and select Xen from the grub menu!

## Further info

For more instructions on using Xapi on Debian, see the wiki page
http://wiki.xen.org/xenwiki/XAPI_on_debian.  For more information on XCP,
please see the wiki at http://wiki.xen.org and search for XCP. Also, check
out #xen-api on freenode and the xen-{api,users,devel} mailing lists.
