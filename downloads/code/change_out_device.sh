#!/bin/bash
 
declare -i count=`pacmd list-sinks | grep -c index:[[:space:]][[:digit:]]`
declare -i active=`pacmd list-sinks | sed -n -e 's/\*[[:space:]]index:[[:space:]]\([[:digit:]]\)/\1/p'`
declare -i major=$count-1
declare -i next=0
 
if [ $active -ne $major ] ; then
next=active+1
fi
 
pacmd "set-default-sink ${next}"
 
for app in $(pacmd list-sink-inputs | sed -n -e 's/index:[[:space:]]\([[:digit:]]\)/\1/p');
do
pacmd "move-sink-input $app $next"
done
 
declare -i ndx=0
pacmd list-sinks | sed -n -e 's/device.description[[:space:]]=[[:space:]]"\(.*\)"/\1/p' | while read line;
do
if [ $next -eq $ndx ] ; then
notify-send -i notification-audio-volume-high "声音输出切换到" "$line"
exit
fi
ndx+=1
done;
