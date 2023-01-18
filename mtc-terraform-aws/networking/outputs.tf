#------ networking/outputs.tf --------

output "vpc_id" {
  value = aws_vpc.aac_vpc.id
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
=======
>>>>>>> bdb105aaccea61416dfcf98445629ca13512f48b
}

output "aws_db_subnet_group_name" {
    value = aws_db_subnet_group.aac_rds_subnetgroup.*.name      #Outputs every private subnet
}

<<<<<<< HEAD
#It is in brackets because we need the whole list
output "db_security_group" {
    value = [aws_security_group.aac_sg["rds"].id]   #Using rds key name to return its values
>>>>>>> Stashed changes
=======
output "db_security_group" {
    value = [aws_security_group.aac_sg["rds"].id]   #Using rds key name to return its values
>>>>>>> bdb105aaccea61416dfcf98445629ca13512f48b
}