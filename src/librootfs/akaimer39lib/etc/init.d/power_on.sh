#!/bin/sh
2>/dev/null if pgrep dropbear; then killall -9 dropbear; fi
2>/dev/null if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
2>/dev/null wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
if  iwlist wlan0 scan | grep -i TP 1>/dev/null ; then
# здесь проверка уровня сигнала
        /etc/init.d/wifi
        mkdir -p /etc/dropbear
                if [ ! -f /etc/dropbear/dropbear_rsa_host_key ]; then
                    dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
                    dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key
                    dropbearkey -t dss -f /etc/dropbear/dropbear_dss_host_key
                fi
        dropbear -B
        ntpd -q -p time.windows.com
#здесь запуск rsync
else
        2>/dev/null killall -9 wpa_supplicant
        2>/dev/null killall -9 dropbear
fi
