resource "aws_security_group" "ships_alb" {
  name   = "ships-alb"
  vpc_id = aws_vpc.ships_vpc.id

  # outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ships-alb"
  }
}

resource "aws_security_group_rule" "alb_http" {
  security_group_id = aws_security_group.ships_alb.id

  type = "ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

# TODO: separate
resource "aws_lb" "ships_lb" {
  load_balancer_type = "application"
  name               = "ships-lb"

  security_groups = [aws_security_group.ships_alb.id]
  subnets         = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}
