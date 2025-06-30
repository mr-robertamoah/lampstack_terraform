resource "aws_alb" "alb" {
  name               = "${var.vpc_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.vpc_name}-alb"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "HTTP Listener is active"
      status_code  = "200"
    }
  }
}

# attach a target group (ec2 instance) to the ALB
resource "aws_alb_target_group" "alb_target_group" {
  name     = "${var.vpc_name}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_alb_listener_rule" "http_rule" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_alb_target_group_attachment" "alb_tg_attachment" {
  target_group_arn = aws_alb_target_group.alb_target_group.arn
  target_id        = var.instance_id
  port             = 80
}
