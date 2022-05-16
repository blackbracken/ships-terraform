# LB listener to say hello
resource "aws_lb_listener" "ch77" {
  port     = "80"
  protocol = "HTTP"

  load_balancer_arn = aws_lb.ships_lb.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "hello, crews!"
    }
  }
}
