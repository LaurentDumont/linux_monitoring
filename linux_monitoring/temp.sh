#!/bin/bash
INTERVAL=60
HOST=rp2.coldnorthadmin.com
TYPE=C

while true; do
	timestamp=`date +%s`
	temperature=`/opt/vc/bin/vcgencmd measure_temp | grep -o '[0-9,.]\+'`
	/usr/bin/curl -i -XPOST 'http://10.9.0.3:8086/write?db=linux_monitoring&precision=s' --data-binary "temperature,host=$HOST,type=$TYPE value=$temperature $timestamp"	
	sleep $INTERVAL

done
