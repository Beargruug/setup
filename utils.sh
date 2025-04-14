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

# Function to check if a formula is installed
is_formula_installed() {
  brew list --formula "$1" &> /dev/null
}

# Function to check if a cask is installed via Homebrew or manually
is_cask_installed() {
  # Check if the cask is installed via Homebrew
  if brew list --cask "$1" &> /dev/null; then
    return 0
  fi

  # Check if the app exists in /Applications or ~/Applications
  local app_name
  app_name=$(brew info --cask "$1" | grep -Eo "/Applications/[^ ]+\.app" | head -n 1)
  if [ -n "$app_name" ] && [ -d "$app_name" ]; then
    return 0
  fi

  return 1
}

# General function to check if a package (formula or cask) is installed
is_installed() {
  is_formula_installed "$1" || is_cask_installed "$1"
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
    echo "Installing casks..."
    for cask in "${to_install_cask[@]}"; do
      if is_cask_installed "$cask"; then
        echo "Skipping '$cask': already installed."
      else
        echo "Installing '$cask'..."
        brew install --cask "$cask"
      fi
    done
  fi
}
