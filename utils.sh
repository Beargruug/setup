#!/usr/bin/env zsh

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if ! command -v brew &> /dev/null; then
    echo "Homebrew installation failed."
    exit 1
  fi
else
  echo "Homebrew is already installed."
fi

# Function to check if a formula is installed
is_formula_installed() {
  brew list --formula "$1" &> /dev/null
}

# Function to check if a cask is installed (via Homebrew or manually)
is_cask_installed() {
  # Check if installed via Homebrew
  if brew list --cask "$1" &> /dev/null; then
    return 0
  fi

  # Check if app exists in Applications folder
  local app_path
  app_path=$(brew info --cask "$1" | grep -Eo "/Applications/[^ ]+\.app" | head -n 1)
  [[ -n "$app_path" && -d "$app_path" ]]
}

# Function to install packages
install_packages() {
  local packages=("$@")
  local formulas=()
  local casks=()

  # Sort packages into formulas and casks
  for pkg in "${packages[@]}"; do
    if brew info --formula "$pkg" &> /dev/null; then
      if ! is_formula_installed "$pkg"; then
        formulas+=("$pkg")
      else
        echo "Skipping formula '$pkg': already installed."
      fi
    elif brew info --cask "$pkg" &> /dev/null; then
      if ! is_cask_installed "$pkg"; then
        casks+=("$pkg")
      else
        echo "Skipping cask '$pkg': already installed."
      fi
    else
      echo "Warning: Package '$pkg' not found as a formula or cask."
    fi
  done

  # Install formulas
  if [[ ${#formulas[@]} -gt 0 ]]; then
    echo "Installing formulas: ${formulas[*]}"
    brew install "${formulas[@]}"
  fi

  # Install casks
  if [[ ${#casks[@]} -gt 0 ]]; then
    echo "Installing casks: ${casks[*]}"
    for cask in "${casks[@]}"; do
      echo "Installing '$cask'..."
      brew install --cask "$cask" || echo "Failed to install '$cask', continuing..."
    done
  fi
}
