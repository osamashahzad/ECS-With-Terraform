# Creating target group
resource "aws_lb_target_group" "http_target_group" {
  name        = "${var.env}-${var.project_name}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 15
    healthy_threshold   = 2
    unhealthy_threshold = 10
    matcher             = "200"
  }

  tags = merge(var.default_tags, {
    Name        = "${var.env}-${var.project_name}-tg"
    description = "target-group for ${var.env}-${var.project_name}"
  })
}

# Creating load balancer
resource "aws_lb" "my_alb" {
  name               = "${var.env}-${var.project_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = merge(var.default_tags, {
    Name        = "${var.env}-${var.project_name}-lb"
    description = "Load Balancer for ${var.env}-${var.project_name}"
  })
}
# Creating Listener

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http_target_group.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.acm_arn # Replace with your certificate ARN

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http_target_group.arn
  }
}
