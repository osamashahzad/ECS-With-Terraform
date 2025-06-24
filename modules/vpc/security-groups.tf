# Load balancer Security Group
resource "aws_security_group" "loadbalancer-sg" {
  name        = "${var.env}-${var.project_name}-lb-sg"
  description = "Security group for load balancer to allow all http/https traffic"
  vpc_id      = aws_vpc.main.id

  # Inbound rules
  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name        = "${var.env}-${var.project_name}-lb-sg"
    description = "sg for loadbalancer-${var.env}-${var.project_name}"
  })
}

# ECS Security Group
resource "aws_security_group" "ecs-sg" {
  name        = "${var.env}-${var.project_name}-ecs-sg"
  description = "Security group for ecs to accept traffic from load balancer"
  vpc_id      = aws_vpc.main.id

  # Inbound rules
  dynamic "ingress" {
    for_each = var.ecs_ports
    content {
      description     = "Allow traffic on port ${ingress.value} from LB"
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.loadbalancer-sg.id]
    }
  }

  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name        = "${var.env}-${var.project_name}-ecs-sg"
    description = "sg for ecs-${var.env}-${var.project_name}"
  })
}

