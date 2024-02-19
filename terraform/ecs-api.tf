module "api" {
  source = "../../../modules/ecs-private-service"

  app_name                   = local.app_name
  ecs_cluster_id             = aws_ecs_cluster.main.id
  ect_task_security_group_id = aws_security_group.ecs_tasks.id
  execution_role_arn         = aws_iam_role.ecs_task_execution_role.arn
  lb_security_group_id       = aws_security_group.lb.id
  log_group_name             = aws_cloudwatch_log_group.weather.name
  namespace_id               = aws_service_discovery_private_dns_namespace.weather.id
  subnet_ids                 = module.vpc.private_subnets
  region                     = local.region
  repository_url             = aws_ecr_repository.weather_api.repository_url
  service_name               = "weather-api"
  task_role_arn              = aws_iam_role.ecs_task_role.arn
  vpc_id                     = module.vpc.vpc_id
}
