#!/bin/bash
# Database Tier User Data Script for Ubuntu AMI

# Update system
apt-get update -y

# Install MySQL Server
apt-get install -y mysql-server

# Secure MySQL installation
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root_password';"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "DROP DATABASE IF EXISTS test;"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -e "FLUSH PRIVILEGES;"

# Configure MySQL for remote connections
sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Execute database setup
mysql -u root -proot_password < /home/ubuntu/three_tier_architecture/db_tier/setup.sql

# Restart MySQL
systemctl restart mysql
systemctl enable mysql

# Configure firewall (allow MySQL from app tier only)
ufw allow from ${app_tier_subnet} to any port 3306
ufw allow 22/tcp
ufw --force enable

# Create backup script
cat > /opt/backup_db.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/opt/backups"
mkdir -p $BACKUP_DIR
DATE=$(date +%Y%m%d_%H%M%S)
mysqldump -u root -proot_password lamp_app > $BACKUP_DIR/lamp_app_$DATE.sql
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
EOF

chmod +x /opt/backup_db.sh

# Schedule daily backup
echo "0 2 * * * root /opt/backup_db.sh" >> /etc/crontab