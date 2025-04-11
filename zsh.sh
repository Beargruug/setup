#!/usr/bin/env zsh

cd ~

if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is already installed. Skipping installation."
else
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ -f ".zshrc" ]; then
  echo ".zshrc already exists. Skipping copy."
else
  echo "Copying .zshrc to home directory."
  cp .dotfiles/zsh/.zshrc ~/
fi

