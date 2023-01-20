#--- compute/main.tf ---

data "aws_ami" "server_ami" {
  most_recent = true #Always want the most recent version, depends on environment  
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

#Random id to use for Instance so we can tell instances apart
resource "random_id" "aac_node_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "aac_auth" {
    key_name = var.key_name
    public_key = file(var.public_key_path) #Don't want this hard-coded since it can change 
}

resource "aws_instance" "aac_node" {
  count         = var.instance_count #1
  instance_type = var.instance_type  #t3.micro
  ami           = data.aws_ami.server_ami.id
  tags = {
    Name = "aac-node-${random_id.aac_node_id[count.index].dec}"
  }
  key_name = aws_key_pair.aac_auth.id
  vpc_security_group_ids = var.public_sg
  subnet_id              = var.public_subnets[count.index]
  user_data = templatefile(var.user_data_path, #Passing in the variables that will be used in the file
  {
    nodename = "aac-node-${random_id.aac_node_id[count.index].dec}"
    db_endpoint = var.db_endpoint
    dbuser = var.dbuser
    dbpass = var.dbpassword
    dbname = var.db_name
  }
  )
  root_block_device {
    volume_size = var.vol_size # 10 GiB
  }
}

resource "aws_lb_target_group_attachment" "aac_tg_attach" {
  count = var.instance_count
  target_group_arn = var.lb_target_group_arn
  target_id = aws_instance.aac_node[count.index].id #Getting the ID from each one of our nodes 
  port = var.tg_port
}
