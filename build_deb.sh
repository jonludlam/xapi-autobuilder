#!/bin/bash
set -e
set -x


sudo -E cowbuilder --build --configfile ../pbuilderrc2 $1


