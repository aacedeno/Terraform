#---loadbalancing/outputs.tf

output "lb_target_group_arn" {
    value = aws_lb_target_group.aac_tg.arn
}
output "lb_endpoint" {
    value = aws_lb.aac-lb.dns_name
}