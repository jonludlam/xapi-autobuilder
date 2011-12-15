#!/bin/sh

cat > /target/root/post.sh << EOF
#!/bin/bash
mv /etc/grub.d/20_linux_xen /etc/grub.d/09_linux_xen
/usr/sbin/update-grub2
control_domain=\`uuidgen\`
installation=\`uuidgen\`
echo "CURRENT_INTERFACES='xenbr0'" >> /etc/xcp/inventory
echo "BUILD_NUMBER='0'" >> /etc/xcp/inventory
echo "CONTROL_DOMAIN_UUID='\${control_domain}'" >> /etc/xcp/inventory
echo "INSTALLATION_UUID='\${installation}'" >> /etc/xcp/inventory
echo "MANAGEMENT_INTERFACE='xenbr0'" >> /etc/xcp/inventory
echo "PRIMARY_DISK='/dev/sda1'" >> /etc/xcp/inventory
EOF

cat > /target/etc/network/interfaces <<EOF 
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

chmod +x /target/root/post.sh
chroot /target /root/post.sh

ln -s qemu-linaro /target/usr/share/qemu
mkdir -p /target/usr/share/xcp/packages/files/guest-installer
