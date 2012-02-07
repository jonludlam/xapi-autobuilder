#!/bin/bash

pif=`xe pif-list device=eth0 --minimal`
killall dhclient
xe pif-reconfigure-ip uuid=$pif mode=dhcp
cat > /etc/network/interfaces << EOF
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback
EOF
ifconfig eth0 0.0.0.0

