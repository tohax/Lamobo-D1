#!/bin/sh
while true
do
if dmesg | tail -5 | grep SurpriseRemoved; then /sbin/reboot; fi
sleep 10
done

