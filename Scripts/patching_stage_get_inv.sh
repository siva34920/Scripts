#!/bin/bash

# Define Variables

todayDate='date +%d'
weekNum=$(($todayDate /7 +1))
weekDay='date +%A'
hour='date +%H'

if [ "$hour" -ge "00" -a "$hour" -le "07" ]
then
  inventoryFile=Ansible.Week${weekNum}.Securities.${weekDay}.000000.080000
elif [ "$hour" -ge "08" -a "$hour" -le "15" ]
then
  inventoryFile=Ansible.Week${weekNum}.Securities.${weekDay}.080000.160000
elif [ "$hour" -ge "16" -a "$hour" -le "23" ]
then
  inventoryFile=Ansible.Week${weekNum}.Securities.${weekDay}.160000.000000
else
  inventoryFile=testing-inventory
fi

echo "Using inventory File : ${inventoryFile}"
/etc/ansible/roles/mufg-patching/patching_stage.sh /etc/ansible/patching/${inventoryFile}

  
