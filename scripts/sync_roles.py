#!/usr/bin/env python3
"""Sync existing roles with updated templates."""

import os
import subprocess
import sys
from pathlib import Path

import yaml


def load_roles():
    """Load role configuration from roles.yaml."""
    roles_file = Path("roles.yaml")
    if not roles_file.exists():
        print("Error: roles.yaml not found")
        sys.exit(1)

    with open(roles_file) as f:
        config = yaml.safe_load(f)
        return config.get("roles", [])


def regenerate_role(project_name, template_type):
    """Regenerate a role from its template."""
    print(f"Regenerating {project_name} from {template_type} template...")

    slug = project_name.lower().replace("_", "-").replace(" ", "-")

    # Run cookiecutter
    cmd = [
        "cookiecutter",
        f"templates/{template_type}",
        "--no-input",
        f"project_name={project_name}",
        "--output-dir",
        "/tmp/cookiecutter-output",
        "--overwrite-if-exists",
    ]

    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error: Failed to regenerate {project_name}")
        print(result.stderr)
        return False

    # Move generated files
    try:
        os.rename(f"/tmp/cookiecutter-output/{slug}/role.tf", f"infra/role-{slug}.tf")
        os.rename(
            f"/tmp/cookiecutter-output/{slug}/policy.json",
            f"infra/policies/{slug}-policy.json",
        )
        subprocess.run(["rm", "-rf", f"/tmp/cookiecutter-output/{slug}"], check=True)
        print(f"  Updated infra/role-{slug}.tf")
        print(f"  Updated infra/policies/{slug}-policy.json")
        return True
    except Exception as e:
        print(f"Error: Failed to move files for {project_name}: {e}")
        return False


def main():
    """Main function."""
    roles = load_roles()

    if not roles:
        print("No roles found in roles.yaml")
        return

    print(f"Syncing {len(roles)} role(s) with templates...\n")

    success_count = 0
    failed_count = 0

    for role in roles:
        project_name = role.get("project_name")
        template_type = role.get("template")

        if not project_name or not template_type:
            print(f"Warning: Invalid role configuration: {role}, skipping")
            failed_count += 1
            continue

        if regenerate_role(project_name, template_type):
            success_count += 1
        else:
            failed_count += 1
        print()

    print(f"Sync complete: {success_count} succeeded, {failed_count} failed")

    if failed_count > 0:
        sys.exit(1)


if __name__ == "__main__":
    main()
