#!/bin/bash
rrdtool graph mygraph.png -a PNG --title="NTP # q!of Packets over time" --vertical-label "# of PAAAAACKETS" --start end-12hours --watermark "$(date "+%a %b %e %H:%M coldnorthadmin.com")" --width 700 --height 220 'DEF:pckin_ntp=ntp_pps.rrd:ntp-pck-in:AVERAGE' 'DEF:pckout_ntp=ntp_pps.rrd:ntp-pck-out:AVERAGE' 'LINE1:pckin_ntp#ff0000:Packets IN' 'LINE1:pckout_ntp#0400ff:Packets OUT' 'GPRINT:pckin_ntp:LAST:Packets IN\: %2.1lf #Packets' 'GPRINT:pckout_ntp:LAST:Packets OUT\: %2.1lf #Packets'

rrdtool create /home/laurent/ntp_monitoring/ntp_pps.rrd \
--step 60 \
DS:ntp-pck-in:GAUGE:120:0:U \
DS:ntp-pck-out:GAUGE:120:0:U \
RRA:MIN:0.5:12:1440 \
RRA:MAX:0.5:12:1440 \
RRA:AVERAGE:0.5:1:1440

rrdtool graph mygraph.png -a PNG \
--title="NTP # of Packets over time" \
--vertical-label "# of PAAAAACKETS" \
--watermark "$(date "+%a %b %e %H:%M coldnorthadmin.com")" \
--start end-12h \
--width 700 --height 220 \
'DEF:pckin_ntp=ntp_pps.rrd:ntp-pck-in:AVERAGE' \
'DEF:pckout_ntp=ntp_pps.rrd:ntp-pck-out:AVERAGE' \
'AREA:pckin_ntp#ff0000:Packets IN' \
'AREA:pckout_ntp#0400ff:Packets OUT' \
'GPRINT:pckin_ntp:AVERAGE:Average pcks IN\: %2.1lf #Packets' \
'GPRINT:pckout_ntp:AVERAGE:Average pcks OUT\: %2.1lf #Packets' \
