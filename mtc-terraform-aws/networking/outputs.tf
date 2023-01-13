#------ networking/outputs.tf --------

output "vpc_id" {
  value = aws_vpc.aac_vpc.id
}