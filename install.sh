#!/bin/bash

mkdir -p $HOME/src

# Refresh using:
# pacman -Qqen > src/github.com/sharms/dotfiles/pkglist.txt
sudo pacman -S - < ./pkglist.txt

if pacman -Qi yay > /dev/null; then
    echo "Yay already installed"
else
    echo "Installing yay"
    # Refresh using:
    # pacman -Qqm > src/github.com/sharms/dotfiles/aur-pkglist.txt

    (cd $HOME/src && git clone https://aur.archlinux.org/yay.git aur.archlinux.org/yay && cd aur.archlinux.org/yay && makepkg -si)
fi

# Setup language servers
sudo npm install -g bash-language-server pyright vscode-langservers-extracted typescript

# Setup neovim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
(cd $HOME/src && git clone https://github.com/brainfucksec/neovim-lua.git github.com/brainfucksec/neovim-lua && cd github.com/brainfucksec/neovim-lua && cp -Rv nvim ~/.config/)
cp init.lua ~/.config/nvim/init.lua


# Setup ZSH
if [ -d "${HOME}/.oh-my-zsh" ] ; then
    echo "oh-my-zsh already exists"
else
    echo "Installing oh-my-zsh"
    if pacman -Qi curl > /dev/null ; then
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "Failed to install oh-my-zsh curl is missing"
    fi
fi

cp .zshrc $HOME/.zshrc

echo "Setting up zsh plugins"
if [ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] ; then
    echo "zsh-autosuggestions already installed... Moving on!"
else
    echo "Installing zsh-autosuggestions."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:- ${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] ; then
    echo "zsh-syntax-highlighting already installed... Moving on!"
else
    echo "Installing zsh-syntax-highlighting."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:- ${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cp .p10k.zsh $HOME/.p10k.zsh
# Setup Xorg
cp .Xresources $HOME/.Xresources
cp .xinitrc $HOME/.xinitrc

# Setup i3
mkdir -p $HOME/.config/i3
cp i3/config $HOME/.config/i3/

mkdir -p $HOME/.config/rofi
cp rofi/config $HOME/.config/rofi/

# Setup Battery Charging Threshold
sudo cp battery-charge-threshold.service /etc/systemd/system/battery-charge-threshold.service

# Setup Systemd services
sudo systemctl enable NetworkManager.service
sudo systemctl enable lightdm.service
sudo systemctl enable bluetooth.service
sudo systemctl enable bluetooth.service
sudo systemctl enable battery-charge-threshold.service
sudo systemctl enable fstrim.timer

# Setup Git
git config --global user.email "sharms@snowfoundry.com"
git config --global user.name "Steve Harms"

# Setup SSH
ssh-keygen -t rsa -b 4096

# Setup Clojure
( cd /tmp && \
  curl -O https://download.clojure.org/install/linux-install-1.10.3.998.sh && \
  chmod +x linux-install-1.10.3.998.sh && \
  sudo ./linux-install-1.10.3.998.sh )

# Setup wallpaper
mkdir -p $HOME/wallpaper
cp -r nitrogen $HOME/.config/nitrogen
