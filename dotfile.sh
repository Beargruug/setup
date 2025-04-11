#!/usr/bin/env zsh

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/Beargruug/.dotfiles"
REPO_NAME=".dotfiles"


is_git_installed() {
  command -v git &> /dev/null
}

is_stow_installed() {
  brew list --formula "stow" &> /dev/null
}

init_submodules() {
  git submodule init
  git submodule update
}

if ! is_stow_installed; then
  echo "Install stow first"
  exit 1
fi

if ! is_git_installed; then
  echo "Git is not installed. Please install Git first."
  exit 1
fi

cd ~

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL"
fi

# Check if the clone was successful
if [ $? -eq 0 ]; then
  cd "$REPO_NAME"
  echo "Cloned the repository successfully."
  echo "Initializing submodules..."
  init_submodules

  pushd nvim/.config/nvim
  git checkout main
  echo "Successfully checked out the main branch..."
  popd

  chmod +x macos
  chmod +x install

  source macos
  source install
  echo "Successfully sourced macos and install scripts..."
else
  echo "Failed to clone the repository."
  exit 1
fi
