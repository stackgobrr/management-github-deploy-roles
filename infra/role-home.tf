module "home" {
  source = "git::https://github.com/stackgobrr/tf-module-aws-oidc-deploy-role.git?ref=main"

  project_name = "home"
  environment  = "prod"

  role_name        = "GitHubActionsDeployRole-Home"
  role_description = "IAM role for home GitHub Actions deployments"

  policy_name        = "HomeDeploymentPolicy"
  policy_description = "Policy for home frontend deployment (S3 + CloudFront)"
  policy_json        = file("${path.module}/policies/home-policy.json")

  github_org  = var.github_org
  github_repo = "home"

  tags = {
    Project = "home"
  }
}

output "home_role_arn" {
  description = "ARN of the home IAM role"
  value       = module.home.role_arn
}
