module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.app_name
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b"]
  private_subnets = ["10.0.51.0/24", "10.0.52.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false

  enable_dns_hostnames = true #required for MSSQL RDS
  enable_dns_support   = true
}
