#!/bin/bash

INTERVAL=60
HOST=192.168.25.7

packet_out ()
{
    while true; do
        timestamp=`date +%s`
        /usr/bin/timeout 60s /usr/sbin/tcpdump -n -l -i eth0 port 123 and src host $HOST > /tmp/ntp_pps_out
        po_start=`cat /tmp/ntp_pps_out | wc -l`
        echo "Packet out Start : $po_start" >> /tmp/test_1
        /usr/bin/curl -i -XPOST 'http://10.9.0.3:8086/write?db=ntp_pps&precision=s' --data-binary "ntp_packets_out,host=rp2.coldnorthadmin.com value=$po_start $timestamp"
    done
}

packet_out
