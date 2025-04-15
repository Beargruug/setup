#!/usr/bin/env zsh

cd ~ || exit

if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is already installed. Skipping installation."
else
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ -f ".zshrc" ]; then
  echo ".zshrc already exists. Replace will be done soon young Jedi."
  rm ~/.zshrc
fi

echo "Copying .zshrc to home directory."
cp .dotfiles/zsh/.zshrc ~/

echo "Successfully copied .zshrc to home directory."

source ~/.zshrc

echo "Oh My Zsh installation completed successfully."
