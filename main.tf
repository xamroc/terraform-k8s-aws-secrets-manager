data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
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

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.23.0"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = 50
    instance_types         = ["t3.medium"]
  }

  eks_managed_node_groups = {
    eks_nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }

  enable_irsa = true
}

resource "helm_release" "csi_secrets_store_provider_aws" {
  name        = "csi-secrets-store-provider-aws"
  repository  = "https://aws.github.io/eks-charts"
  chart       = "csi-secrets-store-provider-aws"
  version     = "0.0.3"

  namespace   = "kube-system"

  depends_on = [
    module.eks
  ]
}