GIT_BRANCH := $(shell git symbolic-ref --short HEAD 2>/dev/null)
GIT_COMMIT := $(shell git log -1 --pretty=%H)

.PHONY: help install install-all test lint format pre-commit clean reset print-version

help: ## Show this help message
	@echo "============================================================================"
	@grep -E '^[a-zA-Z0-9_.-]+:.*##' $(MAKEFILE_LIST) \
		| sed -e 's/:.*##/: /'
	@echo "============================================================================"

.venv: ## Ensure virtual environment exists
	@test -d .venv || uv venv

install-all: .venv ## Install all dependencies and dev tools
	uv sync --all-extras --dev
	direnv allow
	uv run pre-commit install

install: .venv ## Install production dependencies only
	uv sync

test: ## Run tests
	uv run pytest tests

lint: ## Run linter
	uv run ruff check src tests

format: ## Auto-format code
	uv run ruff format src tests

pre-commit: ## Run pre-commit hooks on all files
	uv run pre-commit run --all-files

clean: ## Clean up build and cache files
	rm -rf .pytest_cache .ruff_cache

reset: ## Remove venv and reinstall everything
	rm -rf .venv
	make install-all

print-version: ## Print current Git branch, commit
	@echo "Branch: $(GIT_BRANCH)"
	@echo "Commit: $(GIT_COMMIT)"
