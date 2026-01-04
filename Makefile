.PHONY: help new-spa install-deps

help:
	@echo "Available targets:"
	@echo "  make new spa <project-name>  - Create a new single-page application deploy role"
	@echo "  make install-deps            - Install cookiecutter if not present"
	@echo ""
	@echo "Example:"
	@echo "  make new spa my-app"

install-deps:
	@if [ ! -d .venv ]; then \
		echo "Creating virtual environment..."; \
		python3 -m venv .venv; \
	fi
	@.venv/bin/pip install cookiecutter > /dev/null 2>&1 && echo "Dependencies installed"

new:
	@if [ ! -f .venv/bin/cookiecutter ]; then \
		echo "Error: cookiecutter not found. Run 'make install-deps' first."; \
		exit 1; \
	fi; \
	TEMPLATE_TYPE=$(word 2,$(MAKECMDGOALS)); \
	PROJECT_NAME=$(word 3,$(MAKECMDGOALS)); \
	if [ "$$TEMPLATE_TYPE" = "spa" ]; then \
		if [ -z "$$PROJECT_NAME" ]; then \
			echo "Error: Project name is required"; \
			echo "Usage: make new spa <project-name>"; \
			exit 1; \
		fi; \
		echo "Generating SPA deploy role for project: $$PROJECT_NAME"; \
		.venv/bin/cookiecutter templates/spa --no-input project_name=$$PROJECT_NAME --output-dir /tmp/cookiecutter-output; \
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
