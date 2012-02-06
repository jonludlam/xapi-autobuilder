#!/bin/bash

pif=`xe pif-list device=eth0 --minimal`
ifconfig eth0 0.0.0.0
xe pif-reconfigure-ip uuid=$pif mode=dhcp

