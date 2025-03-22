# Project Name (Change if needed)
PROJECT_NAME = my_project

# Python Virtual Environment Directory
VENV_DIR = venv

# Default Python Interpreter
PYTHON = python3

# Auto-activate venv using direnv
ENVRC_FILE = .envrc

# List of dependencies (Add more if needed)
REQUIREMENTS = requirements.txt

# Define the main Jupyter notebook directory
NOTEBOOKS_DIR = notebooks

# ==============================
# 🔹 Setup & Environment
# ==============================
.PHONY: help
## 📖 Show help message
help:
	@echo "📖 Available commands:"
	@grep -E '##' $(MAKEFILE_LIST) | sed -e 's/##//g' | column -t -s ':'


## 🛠️ Setup the project (venv, direnv, dependencies)
setup: $(VENV_DIR) $(ENVRC_FILE) install

## 🏗️ Create the virtual environment
$(VENV_DIR):
	@echo "🔧 Creating virtual environment..."
	@$(PYTHON) -m venv $(VENV_DIR)

## 📌 Set up .envrc for direnv
$(ENVRC_FILE):
	@echo "📌 Setting up .envrc..."
	@echo 'layout python3' > $(ENVRC_FILE)
	@echo 'export PYTHONPATH=$$(pwd)/src' >> $(ENVRC_FILE)
	@direnv allow

## 📦 Install dependencies
install:
	@echo "📦 Installing dependencies..."
	@source $(VENV_DIR)/bin/activate && pip install --upgrade pip && \
		test -f $(REQUIREMENTS) && pip install -r $(REQUIREMENTS) || echo "⚠️ No requirements.txt found!"

# ==============================
# 🔹 Running Services
# ==============================

## 🚀 Start JupyterLab
jupyter:
	@echo "🚀 Starting JupyterLab..."
	@jupyter lab $(NOTEBOOKS_DIR)

## 🛑 Stop JupyterLab (if running in background)
stop-jupyter:
	@echo "🛑 Stopping JupyterLab..."
	@pkill -f "jupyter-lab" || echo "⚠️ No Jupyter process found."

## 🏃 Run Python script (e.g., `make run SCRIPT=script.py`)
run:
	@echo "🏃 Running Python script: $(SCRIPT)"
	@python $(SCRIPT)

# ==============================
# 🔹 Cleanup & Utilities
# ==============================

## 🗑️ Clean up cached files
clean:
	@echo "🗑️ Cleaning up..."
	@find . -name "*.pyc" -delete
	@find . -name "__pycache__" -delete
	@rm -rf $(VENV_DIR)

## 🛑 Remove all virtual environment and direnv files
reset:
	@echo "🛑 Removing virtual environment and direnv setup..."
	@rm -rf $(VENV_DIR) $(ENVRC_FILE)
	@direnv deny

## 🔄 Restart Jupyter Notebook
restart-jupyter: stop-jupyter jupyter

# ==============================
# 🔹 Help
# ==============================

