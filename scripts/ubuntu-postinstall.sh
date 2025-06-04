# Things to do after installing ubuntu on a new laptop
# Update all packages
sudo apt-get update && sudo apt-get full-upgrade -y && sudo apt-get autoremove

# Install openssh-server
sudo apt-get install -y openssh-server && sudo systemctl enable ssh && sudo systemctl start ssh

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
