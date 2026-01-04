.PHONY: help new-spa install-deps sync

help:
	@echo "Available targets:"
	@echo "  make new spa <project-name>  - Create a new single-page application deploy role"
	@echo "  make sync                    - Regenerate all roles from templates"
	@echo "  make install-deps            - Install dependencies with uv"
	@echo ""
	@echo "Examples:"
	@echo "  make new spa my-app"
	@echo "  make sync"

install-deps:
	@which uv > /dev/null || (echo "Error: uv not found. Install with: curl -LsSf https://astral.sh/uv/install.sh | sh" && exit 1)
	@uv sync && echo "Dependencies installed"

sync:
	@which uv > /dev/null || (echo "Error: uv not found. Run 'make install-deps' first." && exit 1)
	@uv run python scripts/sync_roles.py

new:
	@which uv > /dev/null || (echo "Error: uv not found. Run 'make install-deps' first." && exit 1); \
	TEMPLATE_TYPE=$(word 2,$(MAKECMDGOALS)); \
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
		mv /tmp/cookiecutter-output/$$SLUG/role.tf roles/$$SLUG.tf; \
		mv /tmp/cookiecutter-output/$$SLUG/policy.json policies/$$SLUG-policy.json; \
		rm -rf /tmp/cookiecutter-output; \
		echo ""; \
		echo "Created files:"; \
		echo "  - roles/$$SLUG.tf"; \
		echo "  - policies/$$SLUG-policy.json"; \
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
