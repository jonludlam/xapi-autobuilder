#!/bin/bash
set -e
set -x

sudo pbuilder --build --configfile ../pbuilderrc $1


