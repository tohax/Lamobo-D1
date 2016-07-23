#!/bin/sh
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
if iwlist wlan0 scan | grep -i TP 1>/dev/null ; then
	/etc/init.d/wifi
	Signal=$(iwconfig wlan0 | grep Link | cut -d "=" -f 2 | cut -d "/" -f 1)
	if [ $Signal -ge 30 ]; then
         dropbear -B
         ntpd -q -p time.windows.com
	 #здесь запуск rsync
	echo heartbeat > /sys/class/leds/r_led/trigger
	sleep 0.5
	echo heartbeat > /sys/class/leds/g_led/trigger

dropbearkey -y -f /etc/dropbear/rsa_key | grep ssh | DROPBEAR_PASSWORD='root' dbclient -y root@192.168.1.109 'cat >> .ssh/authorized_keys && echo "Key copied"'
rsync -avz --log-file=/etc/rsync.txt -e "dbclient -y -i /etc/dropbear/rsa_key" /mnt/`hostname` root@192.168.1.109:/mnt/hdd/oneday
echo default-on > /sys/class/leds/r_led/trigger
echo default-on > /sys/class/leds/g_led/trigger
# конец rsync
	fi
else
        if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
        if pgrep dropbear; then killall -9 dropbear; fi
fi
