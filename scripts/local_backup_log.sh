#!/bin/bash

#Remove old log and rotate
rm -f /var/www/html/status/local_backup.log.1
mv /var/www/html/status/local_backup.log /var/www/html/status/local_backup.log.1
