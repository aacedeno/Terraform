#------loadbalancing/main.tf ------

resource "aws_lb" "aac-lb" {
  name            = "aac-loadbalancer"
  subnets         = var.public_subnets
  security_groups = var.public_sg
  idle_timeout    = 400
}

resource "aws_lb_target_group" "aac_tg" {
  name     = "aac-lb-tg-${substr(uuid(), 0, 3)}"
  port     = var.tg_port     #80
  protocol = var.tg_protocol #"HTTP"
  vpc_id   = var.vpc_id
  lifecycle {
    ignore_changes        = [name] #Ignores names changes when a new terraform apply is executed
    create_before_destroy = true   #Ensures a new tg is created before the old one is destroyed; this gives the listener a place to go during this process
  }
  health_check {
    healthy_threshold   = var.lb_healthy_threshold   #2
    unhealthy_threshold = var.lb_unhealthy_threshold #2
    timeout             = var.lb_timeout             #3
    interval            = var.lb_interval            #30
  }
}

resource "aws_lb_listener" "aac_lb_listener" {
  load_balancer_arn = aws_lb.aac-lb.arn
  port              = var.listener_port     #80
  protocol          = var.listener_protocol #HTTP
  default_action {                          #This will determine what happens with traffic that hits LB
    type             = "forward"
    target_group_arn = aws_lb_target_group.aac_tg.arn
  }
}