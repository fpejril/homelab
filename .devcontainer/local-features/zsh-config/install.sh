#!/usr/bin/env bash
set -e

REMOTE_HOME="/home/$_REMOTE_USER"
FONT_DIR="$REMOTE_HOME/.fonts"

mkdir -p $FONT_DIR

curl -o $FONT_DIR/MesloLGS_NF_Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -o $FONT_DIR/MesloLGS_NF_Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -o $FONT_DIR/MesloLGS_NF_Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -o $FONT_DIR/MesloLGS_NF_BoldItalic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

command -v fc-cache && fc-cache

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$REMOTE_HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

ZSHRC="$REMOTE_HOME/.zshrc"

cp ./.zshrc $ZSHRC
cp ./.p10k.zsh $REMOTE_HOME