#!/bin/bash
cd tmp-debs
apt-ftparchive packages . > Packages
cd ..

