

resource "random_string" "random"{
  length = 4
  special = false
  upper = false
}


resource "aws_instance" "web_server" {
  count = var.instance_count
  
  ami               = var.ami_id
  instance_type     = var.ec2_instance_type
  # availability_zone = "us-east-1a"      #Need to get Az variable fixed???
  vpc_security_group_ids   = [aws_security_group.allow_http.id]

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<html><body><div>Hello, world!</div></body></html>" > /var/www/html/index.html
    EOF
}

