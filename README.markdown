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

* Debian Sid/Experimental
* cdebootstrap
* pbuilder

... and possibly more. Let us know if anything breaks due to missing
requirements or dependencies!

## Further info

Please see the wiki at http://wiki.xen.org and search for XCP for more info.
Also, check out #xen-api on freenode and the xen-{api,users,devel} mailing
lists.
