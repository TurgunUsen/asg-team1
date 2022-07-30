# target group
resource "aws_lb_target_group" "target-group" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "team1-tg"
  port        = 80
  protocol    = "HTTP"
  #target_type = "alb"
  vpc_id      = aws_default_vpc.default.id
}

# Application Load Balancer
resource "aws_lb" "application-lb" {
  name               = "team1-alb"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-server.id]
  subnets            = data.aws_subnet_ids.subnet.ids
}

# Creating Listener
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.application-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.target-group.arn
    type             = "forward"
  }
}

# attachment 
resource "aws_lb_target_group_attachment" "asg-attach" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_lb.application-lb.id
  port             = 80
}