#!/bin/bash

while true; do
        pi_start="$(ntpq -c iostats | grep "received packets:" | grep -o '[0-9]\+')"
        po_start="$(ntpq -c iostats | grep "packets sent:" | grep -o '[0-9]\+')"
        sleep 60
        pi_after="$(ntpq -c iostats | grep "received packets:" | grep -o '[0-9]\+')"
        po_after="$(ntpq -c iostats | grep "packets sent:" | grep -o '[0-9]\+')"
        let "pi_pps = ($pi_after-$pi_start)/60"
	let "po_pps = ($po_after-$po_start)/60"
	#pi_pps="$((($pi_after-$pi_start)/60))
        #po_pps="$((($po_after-$po_start)/60))
        echo $(date +%s):$pi_pps:$po_pps >> /home/laurent/test_pps.log
        rrdtool update /home/laurent/ntp_monitoring/ntp_pps.rrd N:$pi_pps:$po_pps
done
