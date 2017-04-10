#!/bin/sh
Server=10.10.10.1
echo heartbeat > /sys/class/leds/g_led/trigger
#IP
        if [[ "`cat /mnt/setup.txt | grep IP  | cut -d "=" -f 2`" != "" ]]; then
        IP=$(cat /mnt/setup.txt | grep IP= | cut -d "=" -f 2)
        IP_old=$(cat /etc/init.d/wifi | grep IP= | cut -d "=" -f 2)
        sed -i "/IP=/s/$IP_old/$IP/g" /etc/init.d/wifi
        fi
#Host
        if [[ "`cat /mnt/setup.txt | grep HOST | cut -d "=" -f 2`" != "" ]]; then
        echo `cat /mnt/setup.txt | grep HOST= | cut -d "=" -f 2` > /etc/sysconfig/HOSTNAME
        hostname -F /etc/sysconfig/HOSTNAME
	#mkdir -p /mnt/`hostname`
	#chmod 755 /mnt/`hostname`
	echo `hostname` > /etc/setup
	fi
mkdir -p /etc/dropbear
chmod 755 /etc/dropbear
dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
insmod /etc/8192cu.ko
echo 1 > /sys/class/leds/r_led/brightness
while [ ! -d /sys/class/net/wlan0 ]
do
echo "Connect power adapter"
sleep 5
done
echo 0 > /sys/class/leds/r_led/brightness
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
/etc/init.d/wifi
echo "1-1     0:6     0660    @/etc/init.d/power_on.sh" >> /etc/mdev.conf
echo '$SUBSYSTEM=usb 0:6 0660 $/etc/init.d/power_off.sh' >> /etc/mdev.conf
echo root > /etc/.rsync
chmod 600 /etc/.rsync
echo "Setup finished" >> /etc/setup
cd /etc
rsync -avm --no-o --no-g --password-file=/etc/.rsync setup root@$Server::video/Avtobus/`date +%Y%m%d`/`hostname`/
rm -f /mnt/setup.txt
rm -f /etc/setup
rmmod 8192cu
reboot
