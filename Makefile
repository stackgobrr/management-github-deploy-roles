.PHONY: help new-spa sync setup-hooks update-variables

help:
	@echo "Available targets:"
	@echo "  make new spa <project-name>  - Create a new single-page application deploy role"
	@echo "  make sync                    - Regenerate all roles from templates"
	@echo "  make update-variables        - Update repository variables with deployed role ARNs"
	@echo "  make install-deps            - Install dependencies with uv"
	@echo "  make setup-hooks             - Install pre-commit hooks"
	@echo ""
	@echo "Examples:"
	@echo "  make new spa my-app"
	@echo "  make sync"
	@echo "  make update-variables"

install-deps:
	@which uv > /dev/null || (echo "Error: uv not found. Install with: curl -LsSf https://astral.sh/uv/install.sh | sh" && exit 1)
	@uv sync --all-groups && echo "Dependencies installed"

setup-hooks: install-deps
	@uv run pre-commit install && echo "Pre-commit hooks installed"

sync: install-deps
	@uv run python scripts/sync_roles.py

update-variables: install-deps
	@which gh > /dev/null || (echo "Error: gh CLI not found. Install from: https://cli.github.com/" && exit 1)
	@echo "Updating repository variables with deployed role ARNs..."
	@uv run python scripts/update_repo_variables.py

new: install-deps
	@TEMPLATE_TYPE=$(word 2,$(MAKECMDGOALS)); \
	PROJECT_NAME=$(word 3,$(MAKECMDGOALS)); \
	if [ "$$TEMPLATE_TYPE" = "spa" ]; then \
		if [ -z "$$PROJECT_NAME" ]; then \
			echo "Error: Project name is required"; \
			echo "Usage: make new spa <project-name>"; \
			exit 1; \
		fi; \
		echo "Generating SPA deploy role for project: $$PROJECT_NAME"; \
		uv run cookiecutter templates/spa --no-input project_name=$$PROJECT_NAME --output-dir /tmp/cookiecutter-output; \
		SLUG=$$(echo "$$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr '_' '-' | tr ' ' '-'); \
		mv /tmp/cookiecutter-output/$$SLUG/role.tf infra/role-$$SLUG.tf; \
		mv /tmp/cookiecutter-output/$$SLUG/policy.json infra/policies/$$SLUG-policy.json; \
		rm -rf /tmp/cookiecutter-output; \
		uv run python scripts/add_role.py $$PROJECT_NAME spa; \
		echo ""; \
		echo "Created files:"; \
		echo "  - infra/role-$$SLUG.tf"; \
		echo "  - infra/policies/$$SLUG-policy.json"; \
		echo "  - Updated roles.yaml"; \
		echo ""; \
		echo "Next steps:"; \
		echo "  1. Review the generated files"; \
		echo "  2. Commit and push to deploy"; \
	else \
		echo "Error: Unknown template type '$$TEMPLATE_TYPE'"; \
		echo "Available types: spa"; \
		exit 1; \
	fi

# This allows 'make new spa <name>' syntax
%:
	@:
