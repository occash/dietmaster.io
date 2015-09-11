#!/bin/bash

#sudo apt-get install openssh-server openssh-client

# Install & configure exim4 as smtp server
sudo apt-get install exim4
sudo dpkg-reconfigure exim4-config

# Install and configure database
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org

# Configure port forwarding
#sudo apt-get install iptables-persistent
#sudo iptables -I INPUT -p tcp -m state --state NEW,ESTABLISHED --dport 27017 -j ACCEPT
#sudo sh -c "iptables-save > /etc/iptables/rules.v4"

sudo apt-get install nginx
# In folder geo
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
gunzip GeoIP.dat.gz
gunzip GeoLiteCity.dat.gz