#--- compute.main.tf ---

output "instance" {
    value = aws_instance.aac_node[*]
    sensitive = true
}

output "instance_port" {
    value = aws_lb_target_group_attachment.aac_tg_attach[0].port
}