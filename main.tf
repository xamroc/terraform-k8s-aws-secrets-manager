data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.3"

  name                  = var.cluster_name
  cidr                  = var.vpc_cidr
  azs                   = data.aws_availability_zones.available.names
  private_subnets       = var.vpc_private_subnets
  public_subnets        = var.vpc_public_subnets
  enable_nat_gateway    = true
  enable_dns_hostnames  = true
  enable_dns_support    = true
  enable_dhcp_options   = true
}

