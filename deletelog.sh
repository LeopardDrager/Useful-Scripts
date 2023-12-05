#!/bin/bash


# Remove log file location
location="/home/pi/Documents/.remove.log"

# IF user forgets to add file or directory
if [ $# -eq 0  ] ; then

	echo "$0: not enough arguments"
	exit 1 
fi
# Will not log info
if [ $1 = "-s" ] ; then
	exit 1
else
	echo "${USER}, $(date), $@ " >> $location
	

fi
/bin/rm "$@"

exit
