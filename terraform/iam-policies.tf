data "aws_iam_policy" "AWSAppRunnerServicePolicyForECRAccess" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

data "aws_iam_policy_document" "secrets_manager" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "parameter_store" {
  statement {
    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:GetParametersByPath",
      "ssm:PutParameter"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "api_g_cloudwatch" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "api_g_xray" {
  statement {
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets",
      "xray:GetSamplingStatisticSummaries"
    ]
    resources = ["*"]
  }
}