#!/usr/bin/env zsh

is_ansible_installed() {
  brew list --formula "ansible" &> /dev/null
}

if ! is_ansible_installed; then
  echo "Install ansible first"
  exit 1
fi

pushd ~ || { echo "Error changing directory to home"; exit 1; }

if [ ! -d ".ssh" ]; then
  echo "Creating .ssh directory"
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
fi

popd || { echo "Error changing back to previous directory"; exit 1; }

if [ ! -d "files/ssh_keys" ]; then
    echo "Error: SSH keys directory not found"
    exit 1
fi

echo "Copying SSH keys and config file to ~/.ssh/"

if [ -f ~/.ssh/id_beargruug ]; then
    echo "Info: SSH Keys already exists. Skipping copy."
else
    cp files/ssh_keys/* ~/.ssh/ || { echo "Error copying SSH keys"; exit 1; }
    chmod 600 ~/.ssh/id_beargruug || { echo "Error setting key permissions"; exit 1; }
    chmod 644 ~/.ssh/id_beargruug.pub
    chmod 644 ~/.ssh/config
    echo "Decrypting SSH keys"
    ansible-vault decrypt ~/.ssh/id_beargruug || { echo "Error decrypting SSH key"; exit 1; }
fi

echo "SSH setup completed successfully"
