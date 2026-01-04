# GitHub Deploy Roles Management

This repository manages GitHub Actions OIDC IAM roles and policies for AWS deployments using Infrastructure as Code.

## Features

- Automated role generation using Cookiecutter templates
- Template sync system to keep all roles aligned with latest templates
- Pre-commit hooks for code quality (Terraform fmt/validate, Python linting)
- CI/CD pipeline with automated testing and deployment
- Branch protection with required status checks

## Structure

- `roles/` - IAM role definitions for each project
- `policies/` - IAM policy documents for deployment permissions
- `templates/` - Cookiecutter templates for generating new roles
- `scripts/` - Python automation scripts
- `roles.yaml` - Tracks all roles and their template types

## Prerequisites

Requires:
- [uv](https://docs.astral.sh/uv/) for Python dependency management
- Terraform 1.14.1+

Install dependencies:

```bash
make install-deps
```

Set up pre-commit hooks:

```bash
make setup-hooks
```

## Creating a New Deploy Role

Use the Makefile to generate a new deploy role from a template:

```bash
make new spa my-project
```

This will:
1. Generate a Terraform role file in `roles/my-project.tf`
2. Generate a policy file in `policies/my-project-policy.json`
3. Use sensible defaults based on the template type

### Available Templates

- `spa` - Single-page application (S3 + CloudFront + ACM + Route53)

### Example

```bash
make new spa my-awesome-app
```

Creates:
- `roles/my-awesome-app.tf`
- `policies/my-awesome-app-policy.json`

After generation:
1. Review the generated files
2. Add the role to `roles.yaml`
3. Create a pull request
4. Merge after CI checks pass

## Syncing Roles with Templates

When you update templates, regenerate all existing roles:

```bash
make sync
```

This reads `roles.yaml` and regenerates all roles from their templates.

## Development Workflow

1. Create a feature branch
2. Make your changes
3. Run pre-commit checks: `pre-commit run --all-files`
4. Push and create a pull request
5. CI will run tests automatically
6. Merge when all checks pass

## CI/CD Pipeline

### Test Workflow (Pull Requests)
- Pre-commit checks (formatting, linting, validation)
- Terraform validation
- Python validation with ruff

### Deploy Workflow (Main Branch)
- Automatic Terraform deployment to AWS
- Uses OIDC authentication

## Available Commands

```bash
make help              # Show available targets
make install-deps      # Install Python dependencies
make setup-hooks       # Install pre-commit hooks
make new spa <name>    # Create new SPA deploy role
make sync              # Regenerate all roles from templates
```

## Existing Roles

- `wm-dojo` - Frontend deployment (S3 + CloudFront)
- `clarity` - Backend API deployment (Lambda + API Gateway + DynamoDB)
- `actions-dashboard` - Frontend deployment (S3 + CloudFront)
