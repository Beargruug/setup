#!/usr/bin/env zsh

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
  echo "Homebrew is not installed. Installing Homebrew..."

  # Install Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Verify installation
  if command -v brew &> /dev/null; then
    echo "Homebrew installed successfully!"
  else
    echo "Homebrew installation failed. Please check the logs."
    exit 1
  fi
else
  echo "Homebrew is already installed."
fi

# Function to check if a package is installed (formula or cask)
is_installed() {
  brew list --formula "$1" &> /dev/null || brew list --cask "$1" &> /dev/null
}

# Function to determine if a package is a formula or a cask
is_formula() {
  brew info --formula "$1" &> /dev/null
}

is_cask() {
  brew info --cask "$1" &> /dev/null
}

# Function to install packages if not already installed
install_packages() {
  local packages=("$@")
  local to_install_formula=()
  local to_install_cask=()

  for pkg in "${packages[@]}"; do
    if is_installed "$pkg"; then
      echo "Skipping '$pkg': already installed."
    else
      if is_formula "$pkg"; then
        to_install_formula+=("$pkg")
      elif is_cask "$pkg"; then
        to_install_cask+=("$pkg")
      else
        echo "Warning: Package '$pkg' not found as a formula or cask."
      fi
    fi
  done

  if [ ${#to_install_formula[@]} -ne 0 ]; then
    echo "Installing formulae: ${to_install_formula[*]}"
    brew install "${to_install_formula[@]}"
  fi

  if [ ${#to_install_cask[@]} -ne 0 ]; then
    echo "Installing casks: ${to_install_cask[*]}"
    brew install --cask "${to_install_cask[@]}"
  fi
}
