#!/usr/bin/env python3
"""Add a new role to roles.yaml."""

import sys
from pathlib import Path

import yaml


def add_role(project_name, template_type):
    """Add a role to roles.yaml if it doesn't already exist."""
    roles_file = Path("roles.yaml")

    # Load existing config or create new one
    if roles_file.exists():
        with open(roles_file) as f:
            config = yaml.safe_load(f) or {}
    else:
        config = {}

    roles = config.get("roles", [])

    # Check if role already exists
    if any(r.get("project_name") == project_name for r in roles):
        print(f"Role '{project_name}' already exists in roles.yaml")
        return

    # Add new role
    roles.append({"project_name": project_name, "template": template_type})
    config["roles"] = roles

    # Write back to file
    with open(roles_file, "w") as f:
        yaml.dump(config, f, default_flow_style=False, sort_keys=False)

    print(f"Added '{project_name}' to roles.yaml")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: add_role.py <project_name> <template_type>")
        sys.exit(1)

    add_role(sys.argv[1], sys.argv[2])
