#!/usr/bin/python

import sys
from debian import deb822
import re
import os

arch="i386"
if "ARCH" in os.environ.keys():
	arch=os.environ['ARCH']

arch_override = {
 'eliloader':'all'
}

def get_arch(name,default):
  try:
    return arch_override[name]
  except:
    return default

def find(f, seq):
  """Return first item in sequence where f(item) == True."""
  for item in seq:
    if f(item): 
      return item

def gen_package(binstr, version, release,arch):
	packages = map(lambda x: {'name':x.strip(), 'version':version, 'release':release, 'arch':get_arch(x.strip(), arch)}, binstr.split(','))
	filtered = filter(lambda x: "doc" not in x['name'], packages)
	filtered = filter(lambda x: "xen-hypervisor-4.1-i386" not in x['name'], filtered)
	return filtered

def flatten(listOfLists):
    return reduce(list.__add__, listOfLists)

def get_all_pkg_names(deps):
    dep_pkgs = map(lambda spkg: map(lambda pkg: pkg['name'], spkg['Binary']), deps)
    return flatten(dep_pkgs)
	
def process_dsc(fname):
	f = file(fname)
	pkg = deb822.Sources(f)
	version=pkg['Version'].split('-')[0]
	release=pkg['Version'].split('-')[1]
	return {'Source':pkg['Source'], 
                'Dsc':fname,
		'Version':version,
		'Release':release,
		'Binary':gen_package(pkg['Binary'],version,release,arch),
		'Build-Depends':map(lambda x: x.strip(), pkg['Build-Depends'].split(','))}

def get_binary_deb_name_from_package(pkg):
	return ("%s_%s-%s_%s.deb" % (pkg['name'], pkg['version'], pkg['release'], pkg['arch']))

def find_spkg_from_pkg_name(pkg_name, deps):
    return find(lambda spkg: pkg_name in map(lambda pkg: pkg['name'], spkg['Binary']), deps)

def find_pkg_from_pkg_name(pkg_name, deps):
    spkg = find_spkg_from_pkg_name(pkg_name, deps)
    if spkg:
        return find(lambda pkg: pkg['name']==pkg_name, spkg['Binary'])

def get_binary_deb_name_from_pkg_name(pkg_name,deps):
    package = find_pkg_from_pkg_name(pkg_name,deps)
    if package:
        return get_binary_deb_name_from_package(package)

    
def gen_deps(spkg, deps):
    pkg_names = get_all_pkg_names(deps)
    pkg_deps = filter(lambda name: name in pkg_names, spkg['Build-Depends'])
    all = ""
    for pkg in spkg['Binary']:
	debname=get_binary_deb_name_from_package(pkg)
	all = "%s \"%s\"" % (all, debname)

    for pkg in spkg['Binary']:
        debname=get_binary_deb_name_from_package(pkg)
        mydeps = map(lambda pkg_name: get_binary_deb_name_from_pkg_name(pkg_name,deps), pkg_deps)
#        deps = filter(lambda depname: depname <> None, deps)
        deps_str = ' '.join(mydeps)
        print "%s: %s %s" % (debname,spkg['Dsc'],deps_str)
	print "\techo Building %s depends upon: %s" % (debname,deps_str)
	print "\tls -la"
	print "\trm -f %s\n\t../build_deb.sh %s" % (all,spkg['Dsc'] )
	print "\tls -la"

def gen_default_target(deps):
    pkg_names = get_all_pkg_names(deps)
    default=""
    for spkg in deps:
        for pkg in spkg['Binary']:
            default = "%s %s" % (default, get_binary_deb_name_from_package(pkg))

    print ".PHONY: default\ndefault : %s\n" % default
   
    print ".PHONY: fromcache\nfromcache : \n"

    for spkg in deps:
        for pkg in spkg['Binary']:
            print "\t../fromcache.sh \"%s\"" % get_binary_deb_name_from_package(pkg)

    print ".PHONY: tocache\ntocache : \n"

    for spkg in deps:
        for pkg in spkg['Binary']:
            print "\t../tocache.sh \"%s\"" % get_binary_deb_name_from_package(pkg)
    print "\t../update_latest.sh\n"



deps=map(process_dsc, sys.argv[1:])
gen_default_target(deps)
for spkg in deps:
	gen_deps(spkg, deps)

