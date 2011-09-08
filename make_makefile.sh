#!/bin/bash

pushd tmp-debs
../gen_src_to_bin_deps.py *.dsc > Makefile
popd
