#!/bin/bash
# Web Tier User Data Script for Ubuntu AMI

# Update system
apt-get update -y

# Install Apache and PHP
apt-get install -y apache2 php libapache2-mod-php php-curl

# Enable Apache modules
a2enmod rewrite
a2enmod php8.1

# Copy application files
cd /var/www/html
rm -f index.html

# Copy web application files
cp /home/ubuntu/three_tier_architecture/web_tier/index.php .

# Update app tier URL in the web file
sed -i "s|http://localhost:8080|http://${app_tier_ip}:8080|g" index.php

# Set permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Start and enable Apache
systemctl start apache2
systemctl enable apache2

# Configure firewall
ufw allow 80/tcp
ufw allow 22/tcp
ufw --force enable