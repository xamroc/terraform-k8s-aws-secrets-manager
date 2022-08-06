variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(string)
}

variable "vpc_public_subnets" {
  type = list(string)
}

variable "namespaces" {
  type = list(string)
}
