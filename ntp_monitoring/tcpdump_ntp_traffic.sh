#!/bin/bash
timeout 86400 tcpdump -i eth0 -n port 123 and not src host 192.168.25.7 | awk '{ print gensub(/(.*)\..*/,"\\1","g",$3), $4, gensub(/(.*)\..*/,"\\1","g",$5) }' | awk '{print $1}' > ip_ntp_clients
cat ip_ntp_clients |sort |uniq -c |sort -n > uniq_ip_2
