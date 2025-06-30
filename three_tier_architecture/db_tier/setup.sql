-- Database Tier - Data Layer Setup

-- Create database
CREATE DATABASE IF NOT EXISTS lamp_app;
USE lamp_app;

-- Create application user
CREATE USER IF NOT EXISTS 'app_user'@'%' IDENTIFIED BY 'secure_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON lamp_app.* TO 'app_user'@'%';

-- Create visitors table
CREATE TABLE IF NOT EXISTS visitors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_visit_time (visit_time)
);

-- Insert sample data
INSERT INTO visitors (visit_time) VALUES 
    (NOW() - INTERVAL 1 DAY),
    (NOW() - INTERVAL 2 HOUR),
    (NOW() - INTERVAL 30 MINUTE);

FLUSH PRIVILEGES;