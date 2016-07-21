#!/bin/sh
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
if iwlist wlan0 scan | grep -i TP 1>/dev/null ; then
	/etc/init.d/wifi
	Signal=$(iwconfig wlan0 | grep Link | cut -d "=" -f 2 | cut -d "/" -f 1)
	if [ $Signal -ge 30 ]; then
         dropbear -B
         ntpd -q -p time.windows.com
	 #здесь запуск rsync
	fi
else
        if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
        if pgrep dropbear; then killall -9 dropbear; fi
fi
