resource "aws_security_group" "this" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = var.ingress_port
    to_port         = var.ingress_port
    protocol        = var.ingress_protocol
    cidr_blocks     = var.ingress_cidr_blocks
    security_groups = var.ingress_security_groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = var.name
    Provisioner = "Terraform"
  }
}
