#!/bin/bash

#Remove old log and rotate
rm -f /var/www/html/status/md0_backup.log.1
mv /var/www/html/status/md0_backup.log /var/www/html/status/md0_backup.log.1

#Record status and timestamp
current_time=$(date "+%d.%m.%Y %H:%M:%S")
echo "Backup running. Started: $current_time" > /var/www/html/status/backup_status.txt

#Perform backup main backup
sudo rsnapshot alpha

#Record status and timestamp
current_time=$(date "+%d.%m.%Y %H:%M:%S")
echo "Backup finished: $current_time" > /var/www/html/status/backup_status.txt

#Record backup drive metrics
df -k | grep /dev/sdf1 | awk '{print $4}' > /var/www/html/status/externalhdd_available.txt
df -k | grep /dev/sdf1 | awk '{print $2}' > /var/www/html/status/externalhdd_total.txt
ls /externalhdd/ > /var/www/html/status/externalhdd_list.txt
