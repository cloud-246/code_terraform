resource "aws_lb_target_group" "target_group_project" {
  name     = "load-balancer-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.tg_vpc_id

  health_check {
    interval = 30
    path     = "/"
    protocol = "HTTP"
    timeout  = 5
    healthy_threshold = 3
    unhealthy_threshold = 2
  }

  tags = {
    Name = "lb_target_group"
  }
}
 
resource "aws_lb_target_group_attachment" "attachment_aws" {
  target_group_arn = aws_lb_target_group.target_group_project.arn
  target_id        = var.target_id  # prvate instance id 
  port             = 80
}



resource "aws_lb" "load_balancer_project" {
  name               = "load-balancer-project"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_security_group_id]
  subnets            = var.load_balancer_subnets

  tags = {
    name = "load_balancer"
  }  
}

resource "aws_lb_listener" "listener_project" {       
  load_balancer_arn = aws_lb.load_balancer_project.arn
  port              = var.listener_port  #80
  protocol          = var.listener_protocol  #HTTP
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_project.arn
  }
}
