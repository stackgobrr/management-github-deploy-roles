# GitHub Deploy Roles Management

This repository manages GitHub Actions OIDC IAM roles and policies for AWS deployments.

## Structure

- `roles/` - IAM role definitions for each project
- `policies/` - IAM policy documents for deployment permissions
- `templates/` - Cookiecutter templates for generating new roles

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

After generation, review the files and commit them to deploy the IAM role.

## Prerequisites

Install cookiecutter if not already installed:

```bash
make install-deps
```

Or manually:

```bash
pip install cookiecutter
```

## Existing Roles

- `wm-dojo` - Frontend deployment (S3 + CloudFront)
- `clarity` - Backend API deployment (Lambda + API Gateway + DynamoDB)
- `actions-dashboard` - Frontend deployment (S3 + CloudFront)
