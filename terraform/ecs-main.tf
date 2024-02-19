// Security ========================================

resource "aws_security_group" "lb" {
  name        = "${local.app_name}-ecs-alb"
  description = "controls access to the ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.app_name}-ecs-alb"
  }
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${local.app_name}-ecs-tasks"
  description = "allow inbound access from the ALB only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol    = "TCP"
    from_port   = "8080"
    to_port     = "8080"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    protocol        = "TCP"
    from_port       = "8080"
    to_port         = "8080"
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    self      = true
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.app_name}-ecs-tasks"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name                  = "${local.app_name}-ecs-task-execution-role"
  force_detach_policies = true
  assume_role_policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

resource "aws_iam_role" "ecs_task_role" {
  name                  = "${local.app_name}-ecs-task-role"
  force_detach_policies = true
  assume_role_policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  inline_policy {
    name   = "secrets_manager"
    policy = data.aws_iam_policy_document.secrets_manager.json
  }

  inline_policy {
    name   = "parameter_store"
    policy = data.aws_iam_policy_document.parameter_store.json
  }

  inline_policy {
    name   = "cloudwatch_logs"
    policy = data.aws_iam_policy_document.cloudwatch.json
  }

  inline_policy {
    name   = "xray"
    policy = data.aws_iam_policy_document.api_g_xray.json
  }
}

// Networking ========================================

data "aws_route53_zone" "trakadev" {
  name         = "trakadev.net"
  private_zone = false
}

// Logging ========================================

resource "aws_cloudwatch_log_group" "weather" {
  name              = "/${local.app_name}/ecs"
  retention_in_days = 3
}

// ECS ========================================

resource "aws_service_discovery_private_dns_namespace" "weather" {
  name        = "${local.app_name}.private"
  description = local.app_name
  vpc         = module.vpc.vpc_id
}

resource "aws_ecs_cluster" "main" {
  name = local.app_name
}
