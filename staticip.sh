#!/bin/bash
myssid=$(iwgetid -r)
defaultgateway=`route -n | awk ' {print $2} ' | sed -n '3p'`

echo "Please pick a number from 2-245"
read address
usable=`ping -c5 "192.168.1.$address" | awk ' {print $4, $5} ' | sed -n  "2p"| awk '{print $1}'`
echo $usable



if [ "$usable" == "Destination" ]; then	
	echo "$address is not in use"
	echo "Would you like to use this IP?(y/n)"
	read answer
	if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
		echo "Now setting your wireless IP as 192.168.1.$address"
		nmcli con mod $myssid ipv4.addresses "192.168.1.$address/24"	
		nmcli con mod $myssid ipv4.gateway "$defaultgateway"
		nmcli con mod $myssid ipv4.dns "$defaultgateway"
		nmcli con mod $myssid ipv4.method manual
		nmcli con up $myssid
		hostname -I
	else
		echo "192.168.1.$address is availble but you decided not to use it."	
		sleep 6
		clear 
		exit 1	
	fi	
	
else		
	echo "Destination is already in use! Please try again, but with a diffrent number."
	sleep 5
	clear
	exit 1
	
fi
