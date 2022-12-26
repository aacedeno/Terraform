resource "aws_instance" "web_server1" {
	ami                       = "ami-0dcc1e21636832c5d" #variable
  instance_type             =  var.ec2_instance_type
	availability_zone         =  "us-east-1a"

	user_data                 = nginx download script
}

resource "aws_instance" "web_server2" {
	ami                       = "ami-0dcc1e21636832c5d" #variable
  instance_type             = var.ec2_instance_type
	availability_zone         = "us-east-1b"
	

	user_data                 = nginx download script #Can I use a index.html file here? 
}

resource "aws_instance" "web_server3" {
	ami                       = "ami-0dcc1e21636832c5d" #variable
  instance_type             = var.ec2_instance_type
	availability_zone         = "us-east-1c "
	

	user_data                 = nginx download script
}