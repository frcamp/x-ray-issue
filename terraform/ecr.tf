resource "aws_ecr_repository" "weather_api" {
  name         = "${local.app_name}-api"
  force_delete = true
}

resource "aws_ecr_repository" "weather_frontend" {
  name         = "${local.app_name}-frontend"
  force_delete = true
}
