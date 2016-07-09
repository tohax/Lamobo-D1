#!/bin/sh
#while true
#do
Signal=$(iwconfig wlan0 | grep level | cut -d "=" -f 3 | cut -d " " -f 1)
let "Power = 100 + Signal"

# Does External power exist?
if [ -d /sys/class/net/wlan0 ] ; then
        /etc/init.d/wifi
        if [ $Power -ge 53 ] ; then
         echo "STOYKA"
        else
                echo "BUS"
                fi
else
echo "BUS"
fi
#sleep 10
#done

