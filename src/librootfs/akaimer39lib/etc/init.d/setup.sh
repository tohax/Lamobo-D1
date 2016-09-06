#!/bin/sh
echo heartbeat > /sys/class/leds/g_led/trigger
# Adding usb devices to /dev at boot time
#for i in /sys/class/net/*/uevent; do printf 'add' > "$i"; done 2>/dev/null; unset i
#for i in /sys/bus/usb/devices/*; do
#   case "${i##*/}" in
#   [0-9]*-[0-9]*)
#   printf 'add' > "$i/uevent"
#      ;;
#   esac
#done; unset i

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
	mkdir -p /mnt/`hostname`
	chmod 755 /mnt/`hostname`
	echo `hostname` > /etc/setup
	fi

#mkdir -p /etc/.ssh
#chmod 755 /etc/.ssh
mkdir -p /etc/dropbear
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
#dropbearkey -y -f /etc/dropbear/dropbear_rsa_host_key | grep ssh | DROPBEAR_PASSWORD='root' ssh -y root@10.10.10.2 'cat >> .ssh/authorized_keys'
#dropbearkey -y -f /etc/dropbear/dropbear_rsa_host_key | grep ssh | DROPBEAR_PASSWORD='root' ssh -y root@10.10.10.2 'ssh-keyscan -t ecdsa localhost' | grep ecdsa >> ~/.ssh/known_hosts
#sed -i "//s/localhost/10.10.10.2/g" /etc/.ssh/known_hosts
echo "1-1     0:6     0660    @/etc/init.d/power_on.sh" >> /etc/mdev.conf
echo '$SUBSYSTEM=usb 0:6 0660 $/etc/init.d/power_off.sh' >> /etc/mdev.conf
echo root > /etc/.rsync
chmod 600 /etc/.rsync
echo "Setup finished" >> /etc/setup
cd /etc
rsync -av --no-o --no-g --password-file=/etc/.rsync setup root@10.10.10.2::video/setup/`hostname`/
#rsync -avR --remove-source-files -e "ssh -y -i /etc/dropbear/dropbear_rsa_host_key" setup 10.10.10.2:/mnt/hdd/setup/`hostname`/
rm -f /mnt/setup.txt
#rm -f /etc/setup
reboot
