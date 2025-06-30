module "vpc" {
  source = "./modules/vpc"

  vpc_name = "lampstack-vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "security" {
  source = "./modules/security"

  vpc_name   = module.vpc.vpc_name
  vpc_id     = module.vpc.vpc_id
  public_key = file("~/.ssh/id_rsa.pub")
}

module "bastion" {
  source = "./modules/ec2"

  vpc_id             = module.vpc.vpc_id
  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.security.bastion_sg_id]
  key_name           = module.security.key_name
  tags = {
    Name = "${module.vpc.vpc_name}-bastion"
  }
}

module "web" {
  source = "./modules/ec2"

  vpc_id             = module.vpc.vpc_id
  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.security.web_sg_id]
  key_name           = module.security.key_name
  tags = {
    Name = "${module.vpc.vpc_name}-web"
  }

  user_data = templatefile("${path.module}/../three_tier_architecture/web_tier/user_data.sh", {
    app_tier_ip = module.app.instance_private_ip
  })
}

module "app" {
  source = "./modules/ec2"

  vpc_id             = module.vpc.vpc_id
  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.private_subnet_ids[0]
  security_group_ids = [module.security.app_sg_id]
  key_name           = module.security.key_name
  tags = {
    Name = "${module.vpc.vpc_name}-app"
  }

  user_data = templatefile("${path.module}/../three_tier_architecture/app_tier/user_data.sh", {
    db_tier_ip = module.db.instance_private_ip
  })
}

module "db" {
  source = "./modules/ec2"

  vpc_id             = module.vpc.vpc_id
  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.private_subnet_ids[1]
  security_group_ids = [module.security.db_sg_id]
  key_name           = module.security.key_name
  tags = {
    Name = "${module.vpc.vpc_name}-db"
  }

  user_data = templatefile("${path.module}/../three_tier_architecture/db_tier/user_data.sh", {
    app_tier_subnet = "10.0.20.0/24"
  })
}

module "alb" {
  source = "./modules/alb"

  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [module.security.web_sg_id]
  instance_id        = module.web.instance_id
}