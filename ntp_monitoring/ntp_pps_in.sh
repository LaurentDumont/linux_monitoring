#!/bin/bash

INTERVAL=60
HOST=192.168.25.7

packet_in ()
{
    while true; do
        timestamp=`date +%s`
        /usr/bin/timeout $INTERVAL /usr/sbin/tcpdump -n -l -i eth0 port 123 and src host not $HOST > /tmp/ntp_pps_in
        pi_start=`cat /tmp/ntp_pps_in | wc -l`
        echo "Packet in Start : $pi_start" >> /tmp/test_1
        /usr/bin/curl -i -XPOST 'http://10.9.0.3:8086/write?db=ntp_pps&precision=s' --data-binary "ntp_packets_in,host=rp2.coldnorthadmin.com value=$pi_start $timestamp"
    done

}

packet_in
