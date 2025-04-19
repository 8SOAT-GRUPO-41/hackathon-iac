resource "aws_db_subnet_group" "this" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = var.name
  }
}

resource "aws_db_instance" "this" {
  identifier               = var.identifier
  engine                   = var.engine
  engine_version           = var.engine_version
  instance_class           = var.instance_class
  allocated_storage        = var.allocated_storage
  username                 = var.username
  password                 = var.password
  publicly_accessible      = var.publicly_accessible
  vpc_security_group_ids   = var.vpc_security_group_ids
  db_subnet_group_name     = aws_db_subnet_group.this.name
  skip_final_snapshot      = true
  delete_automated_backups = true
  db_name                  = var.db_name
  parameter_group_name     = var.parameter_group_name

  tags = {
    Name        = var.name
    Provisioner = "Terraform"
  }
}
