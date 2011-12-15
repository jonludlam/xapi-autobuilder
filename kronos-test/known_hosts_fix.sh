#!/bin/bash
# A simple shell script to clean (delete)  ~/.known_hosts file hostname entry.
# This is useful when remote server reinstalled or ssh keys are changed!
# -------------------------------------------------------------------------
# Copyright (c) 2007 nixCraft project <http://cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------
 
host="$1"
 
[[ $# -eq 0 ]] && { echo "Usage: $0 host.name.com"; exit 1;}
 
ips=$(host "$host" | awk -F'address' '{ print $2}' | sed -e 's/^ //g')
ssh-keygen -R "$host"
for i in $ips
do
	ssh-keygen -R "$i"
done
