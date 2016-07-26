#!/bin/sh
echo heartbeat > /sys/class/leds/g_led/trigger
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
	touch /mnt/`hostname`/test
	fi


mkdir /etc/dropbear
dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
echo 1 > /sys/class/leds/r_led/brightness

while [ ! -d /sys/class/net/wlan0 ]
do
echo "Connect power adapter"
sleep 5
done
echo 0 > /sys/class/leds/r_led/brightness

wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
/etc/init.d/wifi
#sleep 5
dropbearkey -y -f /etc/dropbear/dropbear_rsa_host_key | grep ssh | DROPBEAR_PASSWORD='dietpi' ssh -y root@$Server 'cat >> .ssh/authorized_keys'
echo "1-1     0:6     0660    @/etc/init.d/power_on.sh" >> /etc/mdev.conf
echo '$SUBSYSTEM=usb 0:0 660 $/etc/init.d/power_off.sh' >> /etc/mdev.conf
rm -f /mnt/setup.txt
sync
echo default-on > /sys/class/leds/g_led/trigger
reboot
