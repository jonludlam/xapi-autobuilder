#!/bin/bash
set -e
set -x


sudo -E pbuilder --build --configfile ../pbuilderrc2 $1


