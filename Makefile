.PHONY: setup install test lint format pre-commit clean

# Install project in editable mode + dev deps
setup:
	source .venv/bin/activate
	uv sync --all-extras
	direnv allow
	pre-commit install
	pre-commit run --all-files

# Run tests
test:
	uv run pytest tests

# Run linter
lint:
	uv run ruff check src tests

# Auto-format code
format:
	uv run ruff format src tests

# Run pre-commit hooks on all files
pre-commit:
	uv run pre-commit run --all-files
