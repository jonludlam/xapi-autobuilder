#!/bin/bash

rm -rf pristine
rm -rf tmp-build tmp-checkout
rm -f tmp-debs/*
touch tmp-debs/Packages
rm -f pbuilderrc
rm -f hooks/D05deps
rm -f base.tgz
