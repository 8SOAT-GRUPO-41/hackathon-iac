#######################################
# Data Sources
#######################################
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

############################################
# NLB and Listener Data Sources for backend
############################################
data "aws_lb" "backend_nlb" {
  name = var.backend_nlb_name
}

data "aws_lb_listener" "backend_listener" {
  load_balancer_arn = data.aws_lb.backend_nlb.arn
  port              = 80
}
