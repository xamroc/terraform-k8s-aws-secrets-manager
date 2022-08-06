data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_iam_policy" "secrets_manager" {
  for_each = toset(var.namespaces)

  name        = "${var.cluster_name}-${each.key}-secrets-manager-policy"
  description = "AWS Secrets Manager Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:secretsmanager:*:${local.account_id}:secret:${var.cluster_name}/${each.key}/*"
      },
    ]
  })
}

module "aws_secrets_manager_role" {
  for_each = toset(var.namespaces)

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.1.0"

  role_name = "${var.cluster_name}-${each.key}-secrets-manager-role"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${each.key}:default"]
    }
  }

  role_policy_arns = {
    secrets_manager = "arn:aws:iam::${local.account_id}:policy/${var.cluster_name}-${each.key}-secrets-manager-policy"
  }

  depends_on = [
    aws_iam_policy.secrets_manager
  ]
}

resource "kubernetes_annotations" "serviceaccount_default" {
  for_each = toset(var.namespaces)

  api_version = "v1"
  kind        = "ServiceAccount"
  metadata {
    name = "default"
    namespace = each.key
  }
  annotations = {
    "eks.amazonaws.com/role-arn" = "arn:aws:iam::${local.account_id}:role/${var.cluster_name}-${each.key}-secrets-manager-role"
  }

  depends_on = [
    kubernetes_namespace.namespaces,
    module.aws_secrets_manager_role
  ]
}
