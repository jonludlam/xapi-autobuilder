#!/bin/bash
XAPI_INIT_COMPLETE=/var/run/xapi_init_complete.cookie

# Wait for xapi to write its "init complete" cookie: after here it's safe to modify templates.
wait_for_xapi() {
    MAX_RETRIES=50
    RETRY=0
    while [ ${RETRY} -lt ${MAX_RETRIES} ]; do
        if [ -e ${XAPI_INIT_COMPLETE} ]; then
            return 0
        fi
        sleep 1
	echo "waiting for xapi..."
        RETRY=$(( ${RETRY} + 1 ))
    done
    return 1
}

wait_for_xapi

pif=`xe pif-list device=eth0 --minimal`
echo "pif is: $pif"
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

