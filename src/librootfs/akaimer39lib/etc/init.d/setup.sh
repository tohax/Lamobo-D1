#!/bin/sh
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
        mkdir -p /mnt/`hostname`
        chmod 755 /mnt/`hostname`
	echo `hostname` >> /etc/setup
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
dropbearkey -y -f /etc/dropbear/dropbear_rsa_host_key | grep ssh | DROPBEAR_PASSWORD='root' ssh -y root@10.10.10.2 'cat >> .ssh/authorized_keys'
dropbearkey -y -f /etc/dropbear/dropbear_rsa_host_key | grep ssh | DROPBEAR_PASSWORD='root' ssh -y root@10.10.10.2 'ssh-keyscan -t ecdsa localhost' | grep ecdsa >> /etc/.ssh/known_hosts
sed -i "//s/localhost/10.10.10.2/g" /etc/.ssh/known_hosts
echo "Setup finished" >> /etc/setup
echo "1-1     0:6     0660    @/etc/init.d/power_on.sh" >> /etc/mdev.conf
echo '$SUBSYSTEM=usb 0:6 0660 $/etc/init.d/power_off.sh' >> /etc/mdev.conf
scp /etc/setup -i /etc/dropbear/dropbear_rsa_host_key root@10.10.10.2:/mnt/hdd/setup/`hostname`/
rm -f /mnt/setup.txt
rm -f /etc/setup
reboot
