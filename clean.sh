#!/bin/bash

rm -rf pristine
rm -rf tmp-build
rm -f tmp-debs/*
touch tmp-debs/Packages
rm -f pbuilderrc
rm -f hooks/D05deps
rm -f base.tgz
rm -rf repo/apt/debian/{db,dists,pool}
rm -f tmp-debs/.stampfile
