#/usr/bin/env bash
# Things to do after installing ubuntu on a new laptop
# Update all packages
sudo apt-get update && sudo apt-get full-upgrade -y && sudo apt-get autoremove

# Install packages
sudo apt-get install -y \
  openssh-server \
  git \
  zsh && \
  sudo systemctl enable ssh && \
  sudo systemctl start ssh

# Pull SSH public keys
ssh-import-id-gh fpejril

# Change default shell to zsh
chsh -s $(which zsh)
# exec zsh # Breaks process

# Install ohmyzsh and theme
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"
for font_face in Regular Bold Italic "Bold Italic"; do
  font="MesloLGS NF $font_face.ttf"
  wget -qO "$FONTS_DIR/$font" "https://github.com/romkatv/powerlevel10k-media/raw/master/$font"
done

# TODO: After setting up dotfiles repository, clone and copy .p10k.zsh and .zshrc

# Install rustdesk
# Get latest release
rustdesk_latest=$(curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest \
  | jq -r '.assets[] | select(.name | contains("x86_64.deb"))')
rustdesk_latest_name=$(jq -r '.name' <(echo "$rustdesk_latest"))
rustdesk_latest_download_url=$(jq -r '.browser_download_url' <(echo "$rustdesk_latest"))
wget -qO "$rustdesk_latest_name" "$rustdesk_latest_download_url"
sudo apt install -f ./"$rustdesk_latest_name"
rm -f ./"$rustdesk_latest_name"

# Update logind to lock on lid switch
# Bug: Doesn't handle case where HandleLidSwitch... is set but not to lock
grep -q "^HandleLidSwitch=lock$" /etc/systemd/logind.conf || cat <<EOF | sudo tee -a /etc/systemd/logind.conf
HandleLidSwitch=lock
EOF

grep -q "^HandleLidSwitchExternalPower=lock$" /etc/systemd/logind.conf || cat <<EOF | sudo tee -a /etc/systemd/logind.conf
HandleLidSwitchExternalPower=lock
EOF
