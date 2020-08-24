# Please do not manually call this file!
# This script is run by the docker container when it is "run"

# set ownership for filebeat
chown root /etc/filebeat/filebeat.yml
chmod 700 /etc/filebeat/filebeat.yml

# Start filebeat in background
filebeat &

#Run the apache process in the background
/usr/sbin/apache2 -D APACHE_PROCESS &

# Use cron service as foreground process
cron -f
