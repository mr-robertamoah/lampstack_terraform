# Three-Tier LAMP Architecture

This directory contains a restructured version of the PHP application using a three-tier architecture pattern.

## Architecture Overview

### 1. Web Tier (Presentation Layer)
- **Location**: `web_tier/`
- **Purpose**: Handles user interface and presentation logic
- **Technology**: Apache + PHP
- **Port**: 80 (HTTP)
- **Communication**: Makes HTTP requests to App Tier

### 2. Application Tier (Business Logic Layer)
- **Location**: `app_tier/`
- **Purpose**: Processes business logic and API endpoints
- **Technology**: PHP (built-in server)
- **Port**: 8080
- **Communication**: Receives requests from Web Tier, connects to Database Tier

### 3. Database Tier (Data Layer)
- **Location**: `db_tier/`
- **Purpose**: Data storage and management
- **Technology**: MySQL
- **Port**: 3306
- **Communication**: Receives queries from App Tier only

## Deployment Instructions

### Prerequisites
- 3 Ubuntu AMI instances (one for each tier)
- Proper security group configurations
- Network connectivity between tiers

### 1. Database Tier Setup
```bash
# Run on DB tier instance
sudo bash db_tier/user_data.sh
```

### 2. Application Tier Setup
```bash
# Update DB_HOST in user_data.sh with actual DB tier private IP
# Run on App tier instance
sudo bash app_tier/user_data.sh
```

### 3. Web Tier Setup
```bash
# Update APP_TIER_PRIVATE_IP in user_data.sh with actual App tier private IP
# Run on Web tier instance
sudo bash web_tier/user_data.sh
```

## Security Considerations

### Network Security
- Web Tier: Allow HTTP (80) from ALB, SSH (22) from bastion
- App Tier: Allow 8080 from Web Tier subnet, SSH (22) from bastion
- DB Tier: Allow 3306 from App Tier subnet only, SSH (22) from bastion

### Database Security
- Dedicated database user with limited privileges
- No direct external access to database
- Regular automated backups

## Configuration Variables

Replace these placeholders in the user data scripts:
- `APP_TIER_PRIVATE_IP`: Private IP of application tier instance
- `DB_TIER_PRIVATE_IP`: Private IP of database tier instance
- `APP_TIER_SUBNET`: CIDR block of application tier subnet

## Testing

1. Access the web tier via load balancer
2. Check application tier health: `http://app-tier-ip:8080/api/health`
3. Verify database connectivity through application tier

## Benefits of This Architecture

- **Scalability**: Each tier can be scaled independently
- **Security**: Network isolation between tiers
- **Maintainability**: Clear separation of concerns
- **Flexibility**: Easy to modify or replace individual tiers