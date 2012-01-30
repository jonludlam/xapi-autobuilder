#!/bin/bash

# Bring up PIF correctly

PIF=`xe pif-list device=eth0 --minimal`
xe pif-reconfigure-ip uuid=$PIF mode=dhcp

sleep 10
ifconfig eth0 0.0.0.0

# Set up NFS SR

SR=`xe sr-create type=nfs device-config:server=lork.uk.xensource.com device-config:serverpath=/mnt/vol0/nfs1/scratch1/kronos-test name-label=nfs`
POOL=`xe pool-list --minimal`
xe pool-param-set uuid=$POOL default-SR=$SR
HOST=`xe pool-param-get uuid=$POOL param-name=master`
xe pif-scan host-uuid=$HOST

template=`xe template-list name-label="Debian Squeeze 6.0 (32-bit)" --minimal`
vm=`xe vm-install template=$template new-name-label=debian`
network=`xe network-list bridge=xenbr0 --minimal`
vif=`xe vif-create vm-uuid=$vm network-uuid=$network device=0`
xe vm-param-set uuid=$vm other-config:install-repository=http://ftp.uk.debian.org/debian
xe vm-param-set uuid=$vm PV-args="auto-install/enable=true url=http://www.uk.xensource.com/kronos/squeeze_preseed.cfg interface=auto netcfg/dhcp_timeout=600 hostname=myvm domain=uk.xensource.com"
xe vm-start uuid=$vm


ip_timeout="1800"
ip_interval="10"
ip_time=0;

IP=`xe vm-param-get uuid=$vm param-name=networks param-key=0/ip`

while [ $? -eq 1 ] && [[ $ip_time -lt $ip_timeout ]] ; do
        ip_time=$(($ip_time+$ip_interval))
        sleep $ip_interval
        IP="`xe vm-param-get uuid=$vm param-name=networks param-key=0/ip`"
done

IP="`xe vm-param-get uuid=$vm param-name=networks param-key=0/ip`"

if [ $? -eq 1 ]; then
	echo "Debian guest failed to get IP"
	exit 1
fi

