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
	echo `hostname` > /etc/setup
	fi
if [ -d /etc/dropbear ]; then rm -rf /etc/dropbear; fi
mkdir -p /etc/dropbear
chmod 700 /etc/dropbear
dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
insmod /etc/8192cu.ko
echo 1 > /sys/class/leds/r_led/brightness
while [ ! -d /sys/class/net/wlan0 ]
do
echo "Connect power adapter"
sleep 5
done
echo 0 > /sys/class/leds/r_led/brightness
sed '/power/d' /etc/mdev.conf 2>/dev/null
echo "1-1     root:root     660    @/etc/init.d/power_on.sh" >> /etc/mdev.conf
echo '$SUBSYSTEM=usb root:root 660 $/etc/init.d/power_off.sh' >> /etc/mdev.conf
echo root > /etc/.rsync
chmod 600 /etc/.rsync
echo "Setup finished" >> /etc/`hostname`_setup
wpa_supplicant -B -iwlan0 -Dwext -c /etc/wpa_supplicant.conf
/etc/init.d/wifi
dropbear -R -B
ntpd -q -p time.windows.com
sleep 10
hwclock --systohc
rsync -avm --no-o --no-g --password-file=/etc/.rsync /etc/`hostname`_setup root@$Server::video/ya.disk/Avtobus/`date +%Y%m%d`/
rm -f /mnt/setup.txt /etc/`hostname`_setup
umount -l /mnt
yes | /usr/bin/mke2fs -t ext3 /dev/mmcblk0p1
mount /dev/mmcblk0p1 /mnt
rm -rf /mnt/l*
if pgrep wpa_supplicant; then kill -2 `pgrep wpa_supplicant`; fi
rmmod 8192cu
reboot
