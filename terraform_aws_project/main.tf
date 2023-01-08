resource "aws_instance" "web_server" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.ec2_instance_type
  availability_zone      = element(var.azs, count.index)
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  key_name               = "Terraform-Project"
  user_data              = file("apache-user_data.sh")
}