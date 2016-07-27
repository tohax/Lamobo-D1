#!/bin/sh
AP=bus
Server=10.10.10.2
if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
if pgrep dropbear; then killall -9 dropbear; fi
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
if iwlist wlan0 scan | grep -i $AP 1>/dev/null ; then
   /etc/init.d/wifi
   Signal=$(iwconfig wlan0 | grep Link | cut -d "=" -f 2 | cut -d "/" -f 1)
   if [ $Signal -ge 30 ]; then
      dropbear -B
      ntpd -q -p time.windows.com
      sleep 5
      #здесь запуск rsync
      echo heartbeat > /sys/class/leds/r_led/trigger
      sleep 0.5
      echo heartbeat > /sys/class/leds/g_led/trigger
      if [ -d /mnt/`hostname` ]; then rsync -avz --log-file=/etc/rsync.txt -e "ssh -y -i /etc/dropbear/dropbear_rsa_host_key" /mnt/`hostname` root@$Server:/mnt/hdd/oneday; fi
      echo default-on > /sys/class/leds/r_led/trigger
      echo 0 > /sys/class/leds/g_led/brightness
      # конец rsync
   else
      if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
      if pgrep dropbear; then killall -9 dropbear; fi

   fi
else
        if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
        if pgrep dropbear; then killall -9 dropbear; fi
fi
exit
