#!/bin/bash

thiscache=${cache}/${BUILD_NUMBER}

rm -f ${cache}/latest
ln -s ${cache}/${BUILD_NUMBER} ${cache}/latest


