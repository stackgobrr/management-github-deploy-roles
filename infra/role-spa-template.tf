module "spa_template" {
  source = "git::https://github.com/stackgobrr/tf-module-aws-oidc-deploy-role.git?ref=main"

  project_name = "spa-template"
  environment  = "prod"

  role_name        = "GitHubActionsDeployRole-SpaTemplate"
  role_description = "IAM role for spa-template GitHub Actions deployments"

  policy_name        = "SpaTemplateDeploymentPolicy"
  policy_description = "Policy for spa-template frontend deployment (S3 + CloudFront)"
  policy_json        = file("${path.module}/policies/spa-template-policy.json")

  github_org  = var.github_org
  github_repo = "spa-template"

  tags = {
    Project = "spa-template"
  }
}

output "spa-template_role_arn" {
  description = "ARN of the spa-template IAM role"
  value       = module.spa_template.role_arn
}
