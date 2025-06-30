#!/bin/bash
# Application Tier User Data Script for Ubuntu AMI

# Update system
apt-get update -y

# Install PHP and required extensions
apt-get install -y php php-cli php-mysql php-json php-curl

# Create application directory
mkdir -p /opt/app_tier
cd /opt/app_tier

# Copy application files
cp /home/ubuntu/three_tier_architecture/app_tier/api.php .

# Update database host in the API file
sed -i "s/getenv('DB_HOST') ?: 'localhost'/getenv('DB_HOST') ?: '${db_tier_ip}'/g" api.php

# Set environment variables (replace with actual values)
echo 'export DB_HOST="${db_tier_ip}"' >> /etc/environment
echo 'export DB_NAME="lamp_app"' >> /etc/environment
echo 'export DB_USER="app_user"' >> /etc/environment
echo 'export DB_PASSWORD="secure_password"' >> /etc/environment

# Create systemd service for the app tier
cat > /etc/systemd/system/app-tier.service << 'EOF'
[Unit]
Description=Application Tier PHP Service
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/app_tier
ExecStart=/usr/bin/php -S 0.0.0.0:8080 api.php
Restart=always
RestartSec=3
EnvironmentFile=/etc/environment

[Install]
WantedBy=multi-user.target
EOF

# Set permissions
chown -R www-data:www-data /opt/app_tier
chmod +x /opt/app_tier/api.php

# Start and enable the service
systemctl daemon-reload
systemctl start app-tier
systemctl enable app-tier

# Configure firewall
ufw allow 8080/tcp
ufw allow 22/tcp
ufw --force enable