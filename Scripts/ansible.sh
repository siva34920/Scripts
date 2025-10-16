#!/bin/bash
#
#The script its Wrapeer of Patching_stage.sh script, do not remove
#Author build by SIVABALAN

if [[ $# -ne 4 ]]
then
  echo "The Ansible script must not be run manually.Use the Patching_stage.sh script instead"
  exit 1
fi
PATCHINGHOST=$1
SUMMARYLOG=$2
PATCHINGDAY=$3
PATCHINGDATE=$4
ANSIBLEBASELOG="/etc/ansible/patching/log"
ANSIBLELOG=${ANSIBLEBASELOG}/${PATCHINGDAY}/${PATCHINGHOST}_${PATCHINGDATE}_patching
echo Patching $PATCHINGHOST on $PATCHINGDATE | tee -a $ANSIBLELOG
ansible-playbook -i $PATCHINGHOST, /etc/ansible/roles/mufg-patching/mufg-patching.yml | tee -a $ANSIBLELOG

#Analyse ansible log file and report possible issues
UNREACHABLE='grep -i "unreachable=" $ANSIBLELOG | grep -v "unreachable=0" | wc -l'
FAILED='grep -i "failed=" $ANSIBLELOG | grep -v "failed=0" | wc -l'
if [[ $UNREACHABLE -eq 0 ]]
then
  check1=0
else
  check1=1
fi

if [[ $FAILED -eq 0 ]]
then
  check2=0
else
  check2=1
  #Analyse if patching failed due to existence of do NOT Patch file
  DoNOTPATCHFILE='grep CRITICAL $ANSIBLELOG | wc -l'
  if [[ DoNOTPATCHFILE -eq 0 ]]
  then
    check3=0
  else
    check3=1
  fi
fi

if [[ $check1 -eq 0 ]]
then
  if [[ $check2 -eq 0 ]]
  then
    echo "OK: Patching stage on $PATCHINGHOST looks OKAY (Executed at ${PATCHINGDATE}). Ansible log: ${ANSIBLELOG}" | tee -a ${SUMMARYLOG}
  else
    if [[ $check3 -eq 0 ]]
    then
      echo "CRITICAL: $PATCHINGHOST patching looks FAILED (Executed at ${PATCHINGDATE}). Check ansible log ${ANSIBLELOG}" | tee -a ${SUMMARYLOG}
    else
      echo "WARNING: $PATCHINGHOST patching has been SKIPPED as there is a DO NOT FILE on the server. DO NOT MANAULLY PATCH THE SERVER!!" | tee -a ${SUMMARYLOG}
    fi
fi
else
  echo "CRITICAL: $PATCHINGHOST UNREACHABLE (Executed at ${PATCHINGDATE}). Check ansible log ${ANSIBLELOG}" | tee -a ${SUMMARYLOG}
fi