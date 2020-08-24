FROM ubuntu:20.04

# Fix timezone issue
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update
RUN apt-get update && apt-get dist-upgrade -y

# Install necessary packages
RUN apt-get install vim apache2 cron wget gnupg2 apt-transport-https -y

# Install filebeat
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - \
  && echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list \
  && apt-get update && apt-get install filebeat -y

# Enable the apache module in filebeat
RUN filebeat modules enable apache

# Add the filebeat configuration
COPY --chown=root:root filebeat.yml /etc/filebeat/filebeat.yml
RUN chmod 700 /etc/filebeat/filebeat.yml

# Manually set the apache environment variables in order to get apache to work immediately.
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_RUN_DIR=/var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid

# Execute the containers startup script which will start many processes/services
# The startup file was already added when we added "project"
COPY startup.sh /root/startup.sh
CMD ["/bin/bash", "/root/startup.sh"]


