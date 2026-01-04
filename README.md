# GitHub Deploy Roles Management

This repository manages GitHub Actions OIDC IAM roles and policies for AWS deployments.

## Structure

- `roles/` - IAM role definitions for each project
- `policies/` - IAM policy documents for deployment permissions

## Roles

- `wm-dojo` - Frontend deployment (S3 + CloudFront)
- `clarity` - Backend API deployment (Lambda + API Gateway + DynamoDB)
- `actions-dashboard` - Frontend deployment (S3 + CloudFront)
