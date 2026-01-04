module "wm_dojo" {
  source = "git::https://github.com/stackgobrr/tf-module-aws-oidc-deploy-role.git?ref=main"

  project_name = "wm-dojo"
  environment  = "prod"

  role_name        = "GitHubActionsDeployRole-WmDojo"
  role_description = "IAM role for wm-dojo GitHub Actions deployments"

  policy_name        = "WmDojoDeploymentPolicy"
  policy_description = "Policy for wm-dojo frontend deployment (S3 + CloudFront)"
  policy_json        = file("${path.module}/../policies/wm-dojo-policy.json")

  github_org  = var.github_org
  github_repo = "wm-dojo"

  tags = {
    Project = "wm-dojo"
  }
}
