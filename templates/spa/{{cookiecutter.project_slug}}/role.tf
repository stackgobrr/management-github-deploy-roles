module "{{ cookiecutter.project_name_underscore }}" {
  source = "git::https://github.com/stackgobrr/tf-module-aws-oidc-deploy-role.git?ref=main"

  project_name = "{{ cookiecutter.project_slug }}"
  environment  = "{{ cookiecutter.environment }}"

  role_name        = "GitHubActionsDeployRole-{{ cookiecutter.project_name_pascal }}"
  role_description = "IAM role for {{ cookiecutter.project_slug }} GitHub Actions deployments"

  policy_name        = "{{ cookiecutter.project_name_pascal }}DeploymentPolicy"
  policy_description = "Policy for {{ cookiecutter.project_slug }} frontend deployment (S3 + CloudFront)"
  policy_json        = file("${path.module}/../policies/{{ cookiecutter.project_slug }}-policy.json")

  github_org  = var.github_org
  github_repo = "{{ cookiecutter.github_repo }}"

  tags = {
    Project = "{{ cookiecutter.project_slug }}"
  }
}
