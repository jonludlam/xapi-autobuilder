#!/bin/bash

pushd tmp-debs
for i in *.dsc; do
	echo $i | grep "+" > /dev/null
	if [ $? = 0 ]; then
		ts=`echo $i | cut -d+ -f2 | cut -d- -f1 `
		touch -d "UTC 1970-01-01 $ts secs" $i
	else
		touch -d "UTC 1970-01-01 1 secs" $i
        fi 	
done
popd
