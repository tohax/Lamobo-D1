#!/bin/sh
sleep 5
if pgrep dropbear; then killall -9 dropbear; fi
if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
echo
echo "Applying new configuration from /mnt/setup.txt"

#AP
        if ( cat /mnt/setup.txt | grep AP | cut -d "=" -f 2 )1>/dev/null;  then
        AP=$(cat /mnt/setup.txt | grep AP= | cut -d "=" -f 2)
        AP_old=$(cat /etc/init.d/wifi | grep AP= | cut -d "=" -f 2)
        sed -i "/AP=/s/$AP_old/$AP/g" "/etc/init.d/wifi"
        fi
#PASS
        if ( cat /mnt/setup.txt | grep PASS | cut -d "=" -f 2 ) 1>/dev/null; then
        PASS=$(cat /mnt/setup.txt | grep PASS= | cut -d "=" -f 2)
        PASS_old=$(cat /etc/init.d/wifi | grep PASS= | cut -d "=" -f 2)
        sed -i "/PASS=/s/$PASS_old/$PASS/g" "/etc/init.d/wifi"
        fi
#IP
        if ( cat /mnt/setup.txt | grep IP | cut -d "=" -f 2 ) 1>/dev/null; then
        IP=$(cat /mnt/setup.txt | grep IP= | cut -d "=" -f 2)
        IP_old=$(cat /etc/init.d/wifi | grep IP= | cut -d "=" -f 2)
        sed -i "/IP=/s/$IP_old/$IP/g" "/etc/init.d/wifi"
        fi
#GW
        if ( cat /mnt/setup.txt | grep GW | cut -d "=" -f 2 ) 1>/dev/null; then
        GW=$(cat /mnt/setup.txt | grep GW= | cut -d "=" -f 2)
        GW_old=$(cat /etc/init.d/wifi | grep GW= | cut -d "=" -f 2)
        sed -i "/GW=/s/$GW_old/$GW/g" "/etc/init.d/wifi"
        fi
#Server
        if cat /mnt/setup.txt | grep Server | cut -d "=" -f 2 1>/dev/null; then
        echo
        fi
#Host
        if cat /mnt/setup.txt | grep HOST | cut -d "=" -f 2 1>/dev/null; then
        echo `cat /mnt/setup.txt | grep HOST | cut -d "=" -f 2` > /etc/sysconfig/HOSTNAME
        hostname -F /etc/sysconfig/HOSTNAME
        mkdir -p /mnt/`hostname`
        chmod 755 /mnt/`hostname`
        fi
mkdir -p /etc/dropbear
 if [ ! -f /etc/dropbear/dropbear_rsa_host_key ]; then
  dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
  dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key
  dropbearkey -t dss -f /etc/dropbear/dropbear_dss_host_key
 fi
if [ -d /sys/class/net/wlan0 ]; then /etc/init.d/power_on.sh; fi
rm -f /mnt/setup.txt
