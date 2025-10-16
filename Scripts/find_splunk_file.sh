#!/bin/bash

# Define the varibale for the splunk Package
SPLUNK_TAR=/tmp/splunk.tgz

# find the path were the splunk installed already
if find /opt /app -type d -name "splunk*" | grep -q "/opt/splunk*";then
   echo "Splunk installed on /opt directory"
   echo "Untaring the splunk pacakge on /opt directory"
   tar -xvf "$SPLUNK_TAR" -C /opt;chown -R splunk:splunk /opt/splunk*
elif find /opt /app -type d -name "splunk*" | grep -q "/app/splunk*";then  
     echo "Splunk installed on /app directory"
     echo "Untaring the splunk pacakge on /app directory"
     tar -xvf "$SPLUNK_TAR" -C /app;chown -R splunk:splunk /app/splunk*
else 
    echo " Splunk not found in both /app and /opt directory"
    echo "Need to install manually on server"  
fi
