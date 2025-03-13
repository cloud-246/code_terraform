output "load_balancer_arn" {
    value = aws_lb.load_balancer_project.arn
}

output "target_group_arn" {
    value = aws_lb_target_group.target_group_project.arn
}

output "load_balancer_DNS" {
    value = aws_lb.load_balancer_project.dns_name
}

output "load_balancer_zone_id" {
    value = aws_lb.load_balancer_project.zone_id
}