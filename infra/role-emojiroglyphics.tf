module "emojiroglyphics" {
  source = "git::https://github.com/stackgobrr/tf-module-aws-oidc-deploy-role.git?ref=main"

  project_name = "emojiroglyphics"
  environment  = "prod"

  role_name        = "GitHubActionsDeployRole-Emojiroglyphics"
  role_description = "IAM role for emojiroglyphics GitHub Actions deployments"

  policy_name        = "EmojiroglyphicsDeploymentPolicy"
  policy_description = "Policy for emojiroglyphics frontend deployment (S3 + CloudFront)"
  policy_json        = file("${path.module}/policies/emojiroglyphics-policy.json")

  github_org  = var.github_org
  github_repo = "emojiroglyphics"

  tags = {
    Project = "emojiroglyphics"
  }
}

output "emojiroglyphics_role_arn" {
  description = "ARN of the emojiroglyphics IAM role"
  value       = module.emojiroglyphics.role_arn
}
