#!/usr/bin/env python3
"""Update GitHub repository secrets with deployed IAM role ARNs.

Requires a GitHub App with the following permissions:
- Repository permissions:
  - Secrets: Read and write
  - Contents: Read-only

The GitHub App should be installed on all repositories that need role ARNs.
Set GH_APP_ID and GH_APP_PRIVATE_KEY as secrets in the workflow repository.
"""

import json
import subprocess
import sys
from pathlib import Path

import yaml


def get_terraform_outputs():
    """Get Terraform outputs from infra directory."""
    try:
        result = subprocess.run(
            ["terraform", "output", "-json"],
            cwd="infra",
            capture_output=True,
            text=True,
            check=True,
        )
        return json.loads(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Error getting Terraform outputs: {e.stderr}")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error parsing Terraform output JSON: {e}")
        sys.exit(1)


def load_roles():
    """Load role configuration from roles.yaml."""
    roles_file = Path("roles.yaml")
    if not roles_file.exists():
        print("Error: roles.yaml not found")
        sys.exit(1)

    with open(roles_file) as f:
        config = yaml.safe_load(f)
        return config.get("roles", [])


def get_repo_name(project_name):
    """Get GitHub repository name for a project."""
    # Special case mappings for projects with different repo names
    repo_mappings = {
        "spa-template": "common-template-single-page-app",
    }

    return repo_mappings.get(project_name, project_name)


def set_github_secret(org, repo, secret_name, secret_value):
    """Set a GitHub repository secret using gh CLI."""
    try:
        # Use gh secret set command
        subprocess.run(
            ["gh", "secret", "set", secret_name, "--repo", f"{org}/{repo}"],
            input=secret_value,
            text=True,
            capture_output=True,
            check=True,
        )
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error setting secret for {org}/{repo}: {e.stderr}")
        return False


def main():
    """Main function."""
    print("Fetching Terraform outputs...")
    outputs = get_terraform_outputs()

    print("Loading roles configuration...")
    roles = load_roles()

    if not roles:
        print("No roles found in roles.yaml")
        return

    print(f"\nUpdating secrets for {len(roles)} repository(ies)...\n")

    success_count = 0
    failed_count = 0

    # Get GitHub org from environment or default
    github_org = "stackgobrr"

    for role in roles:
        project_name = role.get("project_name")
        if not project_name:
            print(f"Warning: Role missing project_name: {role}")
            failed_count += 1
            continue

        # Convert project name to output key format
        # e.g., "wm-dojo" -> "wm_dojo_role_arn"
        output_key = f"{project_name.replace('-', '_')}_role_arn"

        if output_key not in outputs:
            print(
                f"Warning: No output found for '{output_key}' (project: {project_name})"
            )
            failed_count += 1
            continue

        role_arn = outputs[output_key]["value"]
        repo_name = get_repo_name(project_name)

        print(f"Setting AWS_ROLE_ARN for {github_org}/{repo_name}...")
        print(f"  ARN: {role_arn}")

        if set_github_secret(github_org, repo_name, "AWS_ROLE_ARN", role_arn):
            print("  ✓ Secret updated successfully")
            success_count += 1
        else:
            print("  ✗ Failed to update secret")
            failed_count += 1

        print()

    print(f"Complete: {success_count} succeeded, {failed_count} failed")

    if failed_count > 0:
        sys.exit(1)


if __name__ == "__main__":
    main()
