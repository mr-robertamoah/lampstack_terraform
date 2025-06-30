output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "web_public_ip" {
  value = module.web.instance_public_ip
}