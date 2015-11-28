#!/bin/sh

base="/home/laurent/ntp_monitoring"
log="$base/ntp.log"
rrd="$base/ntp.rrd"

create()
{
   rrdtool create $rrd --step 60 \
      DS:in:DERIVE:120:0:U \
      DS:out:DERIVE:120:0:U \
      RRA:MIN:0.5:1:2880 \
      RRA:MIN:0.5:15:1344 \
      RRA:MIN:0.5:30:2688 \
      RRA:MIN:0.5:360:2688 \
      RRA:MAX:0.5:1:2880 \
      RRA:MAX:0.5:15:1344 \
      RRA:MAX:0.5:30:2688 \
      RRA:MAX:0.5:360:2688 \
      RRA:AVERAGE:0.5:1:2880 \
      RRA:AVERAGE:0.5:15:1344 \
      RRA:AVERAGE:0.5:30:2688 \
      RRA:AVERAGE:0.5:360:2688
}

update()
{
   pi=$(ntpq -c iostats | grep "received packets:" | grep -o '[0-9]\+')
   po=$(ntpq -c iostats | grep "packets sent:" | grep -o '[0-9]\+')
   echo $(date +%s):$pi:$po >> $log
   rrdtool update $rrd N:$pi:$po
}

graph()
{
   local start=$1
   local fname=$2

   rrdtool graph ${base}/${fname} \
      --start "$start" \
      --title "ntp packets (averages)" \
      --vertical-label "packets per minute" \
      --slope-mode \
      --watermark "$(date "+%a %b %e %H:%M")" \
      --width 500 \
      --height 160 \
\
      "DEF:min_in=$rrd:pckin:MIN" \
      "DEF:max_in=$rrd:pckin:MAX" \
      "DEF:avg_in=$rrd:pckin:AVERAGE" \
\
      "DEF:min_out=$rrd:pckout:MIN" \
      "DEF:max_out=$rrd:pckout:MAX" \
      "DEF:avg_out=$rrd:pckout:AVERAGE" \
\
      "VDEF:icur=avg_in,LAST" \
      "VDEF:imin=min_in,MINIMUM" \
      "VDEF:imax=max_in,MAXIMUM" \
      "VDEF:iavg=avg_in,AVERAGE" \
\
      "VDEF:ocur=avg_out,LAST" \
      "VDEF:omin=min_out,MINIMUM" \
      "VDEF:omax=max_out,MAXIMUM" \
      "VDEF:oavg=avg_out,AVERAGE" \
\
      "LINE2:avg_in#2149b1" \
      "AREA:avg_in#4169e1:Inbound " \
      "GPRINT:icur:Current\: %.0lf" \
      "GPRINT:imin:Minimum\: %.0lf" \
      "GPRINT:imax:Maximum\: %.0lf" \
      "GPRINT:iavg:Average\: %.0lf\n"
}

case $1 in
   init)
      create
      ;;
   update)
      if [ $(id -u) -ne 0 ]; then
         echo "$(basename $0): must be run with root privileges"
         exit 1
      fi
      update
      ;;
   graph)
      graph "-1 day" ntp1d.png
      graph "-1 week" ntp1w.png
      graph "-1 month" ntp1m.png
      graph "-1 year" ntp1y.png
      ;;
   *)
      echo "usage: $(basename $0) <init|update|graph>"
      exit 1
      ;;
esac

