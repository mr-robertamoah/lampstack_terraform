# LAMP Stack Three-Tier Architecture on AWS

This project deploys a scalable three-tier LAMP (Linux, Apache, MySQL, PHP) application on AWS using Terraform.

## Architecture Overview

The infrastructure creates a secure, scalable three-tier architecture:

- **Web Tier**: Apache web server with PHP frontend (public subnet)
- **Application Tier**: PHP API service for business logic (private subnet)  
- **Database Tier**: MySQL database server (private subnet)

## Application Description

A simple visitor tracking application that demonstrates the three-tier pattern:

- **Frontend**: Web interface displaying visitor count and application status
- **API**: RESTful endpoints (`/api/visits`, `/api/health`) handling business logic
- **Database**: MySQL storing visitor timestamps and counts

## Infrastructure Components

### Networking
- VPC with public/private subnets across 2 AZs
- Internet Gateway for public access
- NAT Gateway for private subnet internet access
- Route tables and security groups

### Compute
- **Web Server**: EC2 in public subnet running Apache + PHP
- **App Server**: EC2 in private subnet running PHP API service
- **Database**: EC2 in private subnet running MySQL

### Load Balancing
- Application Load Balancer distributing traffic to web tier
- Target groups and health checks

### Security
- Security groups with least privilege access
- Bastion host for secure SSH access
- Key pair management

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (>= 1.0)
- SSH key pair (`~/.ssh/id_rsa.pub`)

## Usage

1. **Clone and navigate to infrastructure directory**:
   ```bash
   cd infra
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan deployment**:
   ```bash
   terraform plan
   ```

4. **Deploy infrastructure**:
   ```bash
   terraform apply
   ```

5. **Access application**:
   - Use the ALB DNS name from terraform output
   - Or access web server directly via public IP

## Configuration

### Variables
- `profile`: AWS profile (default: "sandbox")
- `region`: AWS region (default: "eu-west-1")
- `instance_type`: EC2 instance type (default: "t2.micro")

### Customization
- Modify CIDR blocks in `modules/vpc/variables.tf`
- Update instance types in `variables.tf`
- Adjust security group rules in `modules/security/`

## Outputs

- `alb_dns_name`: Load balancer endpoint
- `web_public_ip`: Web server public IP

## Cleanup

```bash
terraform destroy
```

## File Structure

```
infra/
├── main.tf              # Main infrastructure configuration
├── variables.tf         # Input variables
├── outputs.tf          # Output values
├── provider.tf         # AWS provider configuration
└── modules/
    ├── vpc/            # VPC and networking
    ├── security/       # Security groups and keys
    ├── ec2/           # EC2 instance module
    └── alb/           # Application Load Balancer

three_tier_architecture/
├── web_tier/          # Frontend PHP application
├── app_tier/          # API PHP application
└── db_tier/           # Database setup scripts
```

## Security Considerations

- Database accessible only from application tier
- Application tier accessible only from web tier
- Web tier accessible via load balancer only
- SSH access through bastion host
- Security groups follow least privilege principle