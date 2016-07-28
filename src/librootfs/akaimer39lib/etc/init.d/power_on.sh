#!/bin/sh
AP=bus
Server=10.10.10.2
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
if iwlist wlan0 scan | grep -i $AP 1>/dev/null ; then
   /etc/init.d/wifi
   Signal=$(iwconfig wlan0 | grep Link | cut -d "=" -f 2 | cut -d "/" -f 1)
   if [ $Signal -ge 30 ]; then
      if pgrep camera.sh; then killall -9 camera.sh; fi
      dropbear -B
      ntpd -q -p time.windows.com
      sleep 5
      #здесь запуск rsync
      echo heartbeat > /sys/class/leds/r_led/trigger
      sleep 0.5
      echo heartbeat > /sys/class/leds/g_led/trigger
      rsync -avz --log-file=/mnt/rsync.txt -e "ssh -y -i /etc/.ssh/id_dropbear" /mnt/`hostname` root@$Server:/mnt/hdd/oneday
      echo default-on > /sys/class/leds/r_led/trigger
      echo 0 > /sys/class/leds/g_led/brightness
      # конец rsync
   else
	/etc/init.d/power_off.sh
   fi
else
   /etc/init.d/power_off.sh
fi
