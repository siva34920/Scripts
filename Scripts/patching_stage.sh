#!/bin/bash
# Wrapper scripts to patch

if [[ $# -ne 1 ]]
then
echo "Usage: patching_stage.sh path_to_file_that_contains_hosts_to_patch"
exit 1
fi
PATCHINGFILE=$1
PATCHINGDAY=`date +"%Y-%m-%d"`
PATCHINGDATE=`date +"%Y-%m-%d_%H:%M:%S"`
ANSIBLEBASELOG="/etc/ansible/patching/log"
ANSIBLELOGDIR=${ANSIBLEBASELOG}/${PATCHINGDAY}
SUMMARYLOG=${ANSIBLELOGDIR}/Patching_summary_${PATCHINGDATE}.log
PATCHINGLIST=${ANSIBLEBASELOG}/Server_Patching_list${PATCHINGDATE}

/usr/bin/mkdir -p ${ANSIBLELOGDIR}/${PATCHINGDAY}
if [[ ! -f $PATCHINGFILE ]]
then
echo The file with the hosts to patch does not exist
exit 1
fi
# Remove servers in the patching file that have been commented adding # at the beginning of the line
grep -v "^#" $PATCHINGFILE > ${PATCHINGLIST}
TOTALSERVERS=`cat ${PATCHINGLIST} | wc -1`
for server in `cat ${PATCHINGLIST}`
do
/etc/ansible/roles/mufg-patching/ansible.sh $server
done
wait
# Verify if number of servers reported in SUMMARYLOG file is the same than in PATCHINGLIST file
SUMMARYSERVERS=`cat $SUMMARYLOG | wc -1`
echo -e "\n\n\n====================================================================="
echo -e "================================================================================"
if [[ $SUMMARYSERVERS -eq $TOTALSERVERS ]]
then
echo "PATCHING EXECUTIONS COMPLETED, please review patching results available in ${ANSIBLELOGDIR}"
echo "A summary of the patching is available in ${SUMMARYLOG} :"
/usr/bin/cat ${SUMMARYLOG}
else
echo "WARNING! : Patching completed but the count of servers in the patching summary file ${SUMMARYLOG} does not match the li
ts available for each server in ${ANSIBLELOGDIR}"
fi
echo -e "\n================================================================================"
echo "==================================================="
