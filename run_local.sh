#!/bin/bash

# Exit on error
set -e

# Step 1: Check for virtual environment
if [ ! -d ".venv" ]; then
  echo "🛠 No .venv found. Creating virtual environment..."
  python3 -m venv .venv
fi

# Step 2: Activate venv
source .venv/bin/activate
echo "✅ Activated .venv"

# Step 3: Install dependencies if requirements.txt exists
pip install --upgrade pip
if [ -f "requirements.txt" ]; then
  echo "📦 Installing dependencies from requirements.txt..."
  pip install -r requirements.txt
else
  echo "📦 Installing minimal defaults (fastai + Jupyter)..."
  pip install fastai notebook ipykernel
fi

# Step 4: Register kernel if not already present
if ! jupyter kernelspec list | grep -wq "fastai"; then
  echo "🧠 Registering Jupyter kernel as 'fastai'..."
  .venv/bin/python -m ipykernel install --user --name=fastai --display-name "Python (fastai)"
else
  echo "🔁 Jupyter kernel 'fastai' already registered."
fi

# Step 5: Launch VSCode in current folder
if command -v code &> /dev/null; then
  echo "🚀 Launching VSCode..."
  code .
else
  echo "⚠️ VSCode CLI not found. You can still run notebooks manually."
fi
