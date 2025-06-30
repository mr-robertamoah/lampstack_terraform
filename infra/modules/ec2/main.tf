resource "aws_instance" "instance" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name = var.key_name
  tags = var.tags
  user_data_base64 = base64encode(var.user_data)
}