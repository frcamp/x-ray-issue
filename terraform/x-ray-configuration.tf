// add x-ray sampling rule to exclude all requests for "/health"
resource "aws_xray_sampling_rule" "exclude_health" {
  rule_name      = "exclude_health"
  fixed_rate     = 0
  host           = "*"
  http_method    = "*"
  priority       = 9999
  reservoir_size = 0
  resource_arn   = "*"
  service_name   = "*"
  service_type   = "*"
  url_path       = "/health"
  version        = 1
}