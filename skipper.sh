#!/usr/bin/env zsh

REPO_URL="https://github.com/Beargruug/skipper.nvim"
REPO_NAME="skipper.nvim"


is_git_installed() {
  command -v git &> /dev/null
}

if ! is_git_installed; then
  echo "Git is not installed. Please install Git first."
  exit 1
fi

if [ ! -d ~/personal ]; then
  mkdir ~/personal
fi

cd ~/personal || exit 1

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL"
fi

# Check if the clone was successful
if [ $? -eq 0 ]; then
  cd "$REPO_NAME" || exit 1
  echo "Cloned the repository successfully."

  git checkout master

  echo "Successfully checked out the master branch..."
  popd || exit 1
else
  echo "Failed to clone the repository."
  exit 1
fi
