#!/bin/sh
VAR1="/mnt/zImage"
VAR2="/mnt/root.sqsh4"
VAR3="/mnt/root.jffs2"

echo "Updating zImage..."
/usr/bin/updater local K=${VAR1}

echo "Updating root.sqsh4..."
/usr/bin/updater local MTD1=${VAR2}

echo "Updating root.jffs2..."
/usr/bin/updater local MTD2=${VAR3}

/sbin/reboot
