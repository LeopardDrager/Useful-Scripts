

#used=$(df -Ph | grep '/dev/mapper/vg_2g-lv_dbs' | awk {'print $5'})
#max=1%
#echo $used
#echo $max

#if [ ${used%?} -ge ${max%?} ] ; then
#	echo "The Mount Point "/DB" on $(hostname) has used $used at $(date)"
#fi


#dusage=$(df -Ph | grep -vE '^tmpfs|cdrom' | sed s/%//g | awk '{ if($5 > 1) print $0;}')
#fscount=$(echo "$dusage" | wc -l)
#if [ $fscount -ge 2 ]; then
#echo "$dusage" "Disk Space Alert On $(hostname) at $(date)" 
#else
#echo "Disk usage is in under threshold"
# fi


#!/bin/sh
df -Ph | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5,$1 }' | while read output;
do
  echo $output
    used=$(echo $output | awk '{print $1}' | sed s/%//g)
      partition=$(echo $output | awk '{print $2}')
        if [ $used -ge 100 ]; then
          echo "The partition \"$partition\" on $(hostname) has used $used% at $(date)" | mail -s "Disk Space Alert: $used% Used On $(hostname)" example@gmail.com
          else
          echo "Disk space usage is in under threshold"
            fi
 done

