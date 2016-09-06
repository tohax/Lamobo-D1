
#!/bin/sh
if pgrep wpa_supplicant; then killall -9 wpa_supplicant; fi
rm -rf /var/run/wpa_supplicant
if pgrep dropbear; then killall -9 dropbear; fi
if [ ! `pgrep record_video` ]; then
/etc/init.d/camera.sh &
fi
