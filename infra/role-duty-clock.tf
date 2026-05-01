module "duty_clock" {
  source = "git::https://github.com/stackgobrr/tf-module-aws-oidc-deploy-role.git?ref=main"

  project_name = "duty-clock"
  environment  = "prod"

  role_name        = "GitHubActionsDeployRole-DutyClock"
  role_description = "IAM role for duty-clock GitHub Actions deployments"

  policy_name        = "DutyClockDeploymentPolicy"
  policy_description = "Policy for duty-clock frontend deployment (S3 + CloudFront)"
  policy_json        = file("${path.module}/policies/duty-clock-policy.json")

  github_org  = var.github_org
  github_repo = "duty-clock"

  tags = {
    Project = "duty-clock"
  }
}

output "duty-clock_role_arn" {
  description = "ARN of the duty-clock IAM role"
  value       = module.duty_clock.role_arn
}
