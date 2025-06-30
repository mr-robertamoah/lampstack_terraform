output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "web_public_ip" {
  value = module.web.instance_public_ip
}

output "web_private_ip" {
  value = module.web.instance_private_ip
}

output "bastion_public_ip" {
  value = module.bastion.instance_public_ip
}

output "bastion_private_ip" {
  value = module.bastion.instance_private_ip
}

output "db_private_ip" {
  value = module.db.instance_private_ip
}

output "app_private_ip" {
  value = module.app.instance_private_ip
}