cluster_name        = "cluster-aws-secrets-manager"
cluster_version     = "1.21"
vpc_cidr            = "10.0.0.0/16"
vpc_private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
vpc_public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
namespaces          = ["team-red", "team-blue"]
