#!/bin/bash

set -x
set -e
export PATH=$PATH:/usr/groups/xencore/systems/bin
PWD=`pwd`

HOST=st01

ln -sf kronos-ubuntu-staging-as /usr/groups/netboot/jludlam/$HOST
echo "Rebooting host"

xenuse --reboot -f $HOST
xenuse --reboot -f $HOST

sleep 300

ln -sf default /usr/groups/netboot/jludlam/$HOST

echo "Now waiting for SSH to be up"

ssh_timeout="1200"
ssh_interval="10"
ssh_time=0;

while ! echo | nc $HOST 22 && [[ $ssh_time -lt $ssh_timeout ]] ; do
   ssh_time=$(($ssh_time+$ssh_interval))
   sleep $ssh_interval
done

if [ $ssh_time -ge $ssh_timeout ]; then
   echo "Timed out waiting for SSH to start" 
   exit 1
fi

echo "SSH is up"

./known_hosts_fix.sh $HOST
sshpass -p xenroot ssh root@$HOST -o StrictHostKeyChecking=no echo
sshpass -p xenroot ssh-copy-id root@$HOST -o StrictHostKeyChecking=no


scp ./fix_networking.sh ./run_test_suite.sh $HOST:
sleep 30

ssh $HOST bash ./fix_networking.sh || true

sleep 30

ssh $HOST bash ./run_test_suite.sh 


