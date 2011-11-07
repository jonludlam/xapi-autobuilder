#!/bin/bash

echo "deb http://ftp.uk.debian.org/debian/ squeeze non-free" >> /etc/apt/sources.list
apt-get update
apt-get install firmware-bnx2

perl -pi -e 's/squeeze/unstable/g' /etc/apt/sources.list

apt-get update

echo 'Dpkg::Options {"--force-confnew";}' >> /etc/apt/apt.conf

DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade

echo "deb http://ftp.uk.debian.org/debian/ experimental main" >> /etc/apt/sources.list

apt-get update

apt-get -y install xen-hypervisor-4.1-amd64 linux-image-3.0.0-1-686-pae

apt-get -y install dkms linux-headers-3.0.0-1-686-pae

echo "deb http://downloads.xen.org/XCP/debian/repo/debian unstable main" >> /etc/apt/sources.list
wget -O - http://downloads.xen.org/XCP/debian/xcp.gpg.key | apt-key add -

apt-get update
apt-get install -y xapi
mv /etc/grub.d/20_linux_xen /etc/grub.d/09_linux_xen

update-grub

cat > /etc/network/interfaces <<EOF 
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo xenbr0
iface lo inet loopback

# The primary network interface
iface eth0 inet manual

iface xenbr0 inet dhcp
	bridge_ports eth0

EOF

control_domain=`uuidgen`
installation=`uuidgen`

cat > /etc/xensource-inventory << EOF
CURRENT_INTERFACES='xenbr0'
BUILD_NUMBER='0'
CONTROL_DOMAIN_UUID='${control_domain}'
INSTALLATION_UUID='${installation}'
MANAGEMENT_INTERFACE='xenbr0'
PRIMARY_DISK='/dev/sda1'
EOF

reboot


