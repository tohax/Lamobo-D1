#!/bin/sh
echo heartbeat > /sys/class/leds/g_led/trigger
echo
echo "Applying new configuration from /mnt/setup.txt"
echo
#AP
#        if [[ "`cat /mnt/setup.txt | grep AP | cut -d "=" -f 2`" != "" ]];  then
#        AP=$(cat /mnt/setup.txt | grep AP= | cut -d "=" -f 2)
#        AP_old=$(cat /etc/init.d/wifi | grep AP= | cut -d "=" -f 2)
#        sed -i "/AP=/s/$AP_old/$AP/g" /etc/init.d/wifi
#	sed -i "/AP=/s/$AP_old/$AP/g" /etc/init.d/power_on.sh
#	fi
#PASS
#        if [[ "`cat /mnt/setup.txt | grep PASS | cut -d "=" -f 2`" != "" ]]; then
#        PASS=$(cat /mnt/setup.txt | grep PASS= | cut -d "=" -f 2)
#        PASS_old=$(cat /etc/init.d/wifi | grep PSK= | cut -d "=" -f 2)
#        sed -i "/PASS=/s/$PASS_old/$PASS/g" /etc/init.d/wifi
#        fi
#IP
        if [[ "`cat /mnt/setup.txt | grep IP  | cut -d "=" -f 2`" != "" ]]; then
        IP=$(cat /mnt/setup.txt | grep IP= | cut -d "=" -f 2)
        IP_old=$(cat /etc/init.d/wifi | grep IP= | cut -d "=" -f 2)
        sed -i "/IP=/s/$IP_old/$IP/g" /etc/init.d/wifi
        fi
#GW
#        if [[ "`cat /mnt/setup.txt | grep GW | cut -d "=" -f 2`" != "" ]]; then
#        GW=$(cat /mnt/setup.txt | grep GW= | cut -d "=" -f 2)
#        GW_old=$(cat /etc/init.d/wifi | grep GW= | cut -d "=" -f 2)
#        sed -i "/GW=/s/$GW_old/$GW/g" /etc/init.d/wifi
#        fi
#DNS
#	if [[ "`cat /mnt/setup.txt | grep DNS | cut -d "=" -f 2`" != "" ]]; then
#        DNS=$(cat /mnt/setup.txt | grep DNS= | cut -d "=" -f 2)
#	echo $DNS >> /etc/resolv.conf
#        fi

#Server
#        if [[ "`cat /mnt/setup.txt | grep Server | cut -d "=" -f 2`" != "" ]]; then
#        Server=$(cat /mnt/setup.txt | grep Server= | cut -d "=" -f 2)
#	Server_old=$(cat /etc/init.d/power_on.sh | grep Server= | cut -d "=" -f 2)
#	sed -i "/Server=/s/$Server_old/$Server/g" /etc/init.d/power_on.sh
#	fi
#ServerPWD
#        if [[ "`cat /mnt/setup.txt | grep ServerPWD | cut -d "=" -f 2`" != "" ]]; then
#        ServerPWD=$(cat /mnt/setup.txt | grep ServerPWD= | cut -d "=" -f 2)
#        fi
#Host
        if [[ "`cat /mnt/setup.txt | grep HOST | cut -d "=" -f 2`" != "" ]]; then
        echo `cat /mnt/setup.txt | grep HOST= | cut -d "=" -f 2` > /etc/sysconfig/HOSTNAME
        hostname -F /etc/sysconfig/HOSTNAME
        mkdir -p /mnt/`hostname`
        chmod 755 /mnt/`hostname`
        touch /mnt/`hostname`/test
        fi


mkdir /etc/.ssh
chmod 755 /etc/.ssh
mkdir /etc/dropbear
chmod 755 /etc/dropbear
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
dropbearkey -y -f /etc/dropbear/dropbear_rsa_host_key | grep ssh | DROPBEAR_PASSWORD='dietpi' ssh -y root@10.10.10.2 'cat >> .ssh/authorized_keys'
echo "1-1     0:6     0660    @/etc/init.d/power_on.sh" >> /etc/mdev.conf
echo '$SUBSYSTEM=usb 0:0 660 $/etc/init.d/power_off.sh' >> /etc/mdev.conf
rm -f /mnt/setup.txt
reboot
