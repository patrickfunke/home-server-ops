# Saves some basic metrics to public files for quick checks

df /storage -h > /var/www/html/status/temp.txt
tr ' \n' ',' < /var/www/html/status/temp.txt | tr -s ',' > /var/www/html/status/diskfree-storage.csv
df / -h > /var/www/html/status/temp.txt
tr ' \n' ',' < /var/www/html/status/temp.txt | tr -s ',' > /var/www/html/status/diskfree-root.csv
cat /proc/mdstat > /var/www/html/status/mdstat.txt
date +"%d.%m.%y, %H:%M Uhr" > /var/www/html/status/timestamp.txt
