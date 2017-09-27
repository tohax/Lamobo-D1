#!/bin/sh
Server=192.168.1.100
echo heartbeat > /sys/class/leds/g_led/trigger
#IP
        if [[ "`cat /mnt/setup.txt | grep IP  | cut -d "=" -f 2`" != "" ]]; then
        IP=$(cat /mnt/setup.txt | grep IP= | cut -d "=" -f 2)
        IP_old=$(cat /etc/init.d/wifi.sh | grep IP= | cut -d "=" -f 2)
        sed -i "/IP=/s/$IP_old/$IP/g" /etc/init.d/wifi.sh
        fi
#Host
        if [[ "`cat /mnt/setup.txt | grep HOST | cut -d "=" -f 2`" != "" ]]; then
        echo `cat /mnt/setup.txt | grep HOST= | cut -d "=" -f 2` > /etc/sysconfig/HOSTNAME
        hostname -F /etc/sysconfig/HOSTNAME
	fi
if [ -d /etc/dropbear ]; then rm -rf /etc/dropbear; fi
mkdir -p /etc/dropbear
chmod 700 /etc/dropbear
dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
echo dietpi > /etc/.rsync
chmod 600 /etc/.rsync
#modprobe 8192cu
echo 1 > /sys/class/leds/r_led/brightness
while [ ! -d /sys/class/net/wlan0 ]
do
echo "Connect power adapter"
sleep 5
done
echo 0 > /sys/class/leds/r_led/brightness
if pgrep wpa_supplicant; then kill `pgrep wpa_supplicant`; fi
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
/etc/init.d/wifi.sh
sleep 3
echo "Updating time"
rdate -s $Server
hwclock --systohc
echo `date`
dropbear -R -B
if [ ! -f /etc/mtab ]; then ln -s /proc/mounts /etc/mtab; fi
umount -l /mnt
yes | /usr/bin/mke2fs -t ext3 /dev/mmcblk0p1
mount /dev/mmcblk0p1 /mnt
rm -rf /mnt/*
sed -i '/1-1:1.0/d' /etc/mdev.conf
echo '-1-1:1.0 root:root 0660 $/etc/init.d/off.sh' >> /etc/mdev.conf
echo '1-1:1.0 root:root 0660 @/etc/init.d/on.sh' >> /etc/mdev.conf
echo "Setup finished" >> /etc/`hostname`_setup
rsync -avm --no-o --no-g --password-file=/etc/.rsync /etc/`hostname`_setup root@$Server::video/ya.disk/Avtobus/`date +%Y%m%d`/
rm -f /etc/`hostname`_setup
reboot
