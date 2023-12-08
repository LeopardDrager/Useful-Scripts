#!/bin/bash

Netstat=$(netstat -tnpa | awk '{print $5 , $6}' | grep  "ESTABLISHED" )  #<Mason using https://unix.stackexchange.com/questions/92560/list-all-connected-ssh-sessions
estabChecker=$(netstat -tnpa | awk '{print $6}' | grep -q "ESTABLISHED" && echo "ESTABLISHED" ) #<Mason using https://unix.stackexchange.com/questions/92560/list-all-connected-ssh-sessions
currentLogin=$(w -i | awk '{print $1}' | grep -v "USER") #<Maguire I used this resource https://www.cyberciti.biz/faq/unix-linux-list-current-logged-in-users/
openedPorts=$(ss -ltn | awk '{print $4}' |awk -F':' '{print $NF}' | sort -n | uniq -c | awk '{print $2 " " $1}' | grep -v "Local 1") #<Mason using https://linuxconfig.org/how-to-check-open-ports-on-raspberry-pi
sysLog=$(journalctl --since "60min ago" | awk '{print  $1, $2, $4, $5, $6}' | grep "sshd" | grep "Accepted" | awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7}' ) #<Maguire I used this link https://serverfault.com/questions/932110/how-to-only-look-at-the-last-10-minutes-of-a-log-and-grep-for-statement

echo "This is some simple security for your Raspberry Pi! Would you like to continue? (y/n)"
read choice 
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        echo "This is the most recent SSH login" 
        echo "$sysLog"
            echo "
            "
            sleep 3
    # this is current login checker
    if [ "$currentLogin" = "" ]; then
        echo "No one is logged in"
    else
        echo "These users are logged in"
        echo "$currentLogin"
    fi
    
    # these are opened ports login checker
            sleep 3
            echo "
            "
    if [ "$openedPorts" = "" ]; then
        echo "No ports are open"
    else
        echo "These ports are open"
        echo "$openedPorts"
    fi

            echo "
            "
            sleep 3

    # this is ssh checker 
    if [ "$estabChecker" = "ESTABLISHED" ]; then
        echo -e "SSH is connected via  \n$Netstat"
    fi
            echo "
            "
    
else 
    echo "You either picked no or an invalid option. Exiting now."
    exit 1
# #Maguire I used this link https://serverfault.com/questions/932110/how-to-only-look-at-the-last-10-minutes-of-a-log-and-grep-for-statement
exit 1     
fi

