#######################################
# Security Groups
#######################################

module "hackathon_rds_sg" {
  source              = "./modules/aws/security_group"
  vpc_id              = module.hackathon_vpc.vpc_id
  ingress_port        = 5432
  ingress_protocol    = "tcp"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  name                = "${var.project_name}-rds-sg"
}

#######################################
# RDS Instance
#######################################

module "hackathon_rds" {
  source                 = "./modules/aws/rds"
  identifier             = "hackathon"
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  username               = var.rds_username
  password               = var.rds_password
  publicly_accessible    = true
  vpc_security_group_ids = [module.hackathon_rds_sg.security_group_id]
  name                   = "${var.project_name}-rds"
  subnet_group_name      = "${var.project_name}-subnet-group"
  db_name                = var.rds_db_name
  parameter_group_name   = "postgres16"

  subnet_ids = [
    module.hackathon_public_subnet_a.subnet_id,
    module.hackathon_public_subnet_b.subnet_id
  ]
}
