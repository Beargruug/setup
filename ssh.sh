#!/usr/bin/env zsh

is_ansible_installed() {
  brew list --formula "ansible" &> /dev/null
}
if ! is_ansible_installed; then
  echo "Install ansible first"
  exit 1
fi

pushd ~

if [ ! -d ".ssh" ]; then
  echo "Creating .ssh directory"
  mkdir .ssh
fi

popd

echo "Copying SSH keys and config file to ~/.ssh/"
cp files/ssh_keys/* ~/.ssh/

echo "Setting permissions for SSH keys and config file"
chmod 600 ~/.ssh/id_beargruug
chmod 644 ~/.ssh/id_beargruug.pub
chmod 644 ~/.ssh/config

echo "Decrypting SSH keys"
ansible-vault decrypt ~/.ssh/id_beargruug
