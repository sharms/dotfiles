#!/bin/bash

echo "This will configure my system the way I want it"
echo "Hit ENTER to start"
read x

if [ ! -d "./deps" ]; then
  echo "We also need the deps directory copied over to start"
  exit 1
fi

sudo timedatectl set-ntp true
sudo pacman -S git
echo "Configure makepkg..."
sudo vi /etc/makepkg.conf

echo "Fix Gnupg signature checking..."
mkdir -p ~/.gnupg
cp /usr/share/gnupg/gpg-conf.skel ~/.gnupg/gpg.conf
cp /usr/share/gnupg/dirmngr-conf.skel ~/.gnupg/dirmngr.conf
echo "
# add fix for automated signature checking
# https://wiki.archlinux.org/index.php/Makepkg#Signature_checking

keyserver hkp://pool.sks-keyservers.net
keyserver-options auto-key-retrieve" >> ~/.gnupg/gpg.conf
sudo cp -a ~/.gnupg /root/.gnupg
sudo chown root:root /root/.gnupg

echo "Installing cower..."
gpg --recv-keys 1EB2638FF56C0C53
pushd .
cd /tmp
git clone https://aur.archlinux.org/cower.git
cd cower
makepkg -si --noconfirm --needed
cd -
rm -rf /tmp/cower

echo "Installing pacaur..."
cd /tmp
git clone https://aur.archlinux.org/pacaur.git
cd pacaur
makepkg -si --noconfirm --needed
cd -
rm -rf /tmp/pacaur

echo "Installing Miffe repo"
echo "Receiving keys..."
sudo pacman-key --recv-keys 313F5ABD
sudo pacman-key --lsign-key 313F5ABD
popd
sudo cp deps/pacman.conf /etc/pacman.conf
sudo pacman -Sy

sudo pacman -S gcc-multilib

echo "Installing base packages..."
pacaur --needed --noedit -S \
  autofs \
  visual-studio-code \
  libva-vdpau-driver \
  mesa-vdpau \
  bmon \
  rox \
  exfat-utils \
  lv2-plugins \
  calf \
  qjackctl \
  pavucontrol \
  breeze-icons \
  gnome \
  gnome-extra \
  polkit-gnome \
  cups \
  cups-pdf \
  foomatic-db \
  foomatic-db-ppds \
  foomatic-db-gutenprint \
  foomatic-db-gutenprint-ppds \
  foomatic-db-nonfree \
  foomatic-db-nonfree-ppds \
  exfat-utils \
  iw \
  wpa_supplicant \
  dialog \
  xorg \
  xorg-xinit \
  gdm \
  pulseaudio \
  network-manager-applet \
  openssh \
  htop \
  wireless_tools \
  archey3 \
  tmux \
  git \
  arch-wiki-lite \
  powerline-fonts-git \
  rbenv \
  ruby-build \
  alsa-plugins \
  alsa-tools \
  alsa-utils \
  alsaplayer \
  lib32-alsa-lib \
  pulseaudio-alsa \
  zsh \
  unzip \
  vlc \
  emacs \
  archlinux-artwork \
  flattr-icon-theme \
  gnome-shell-theme-mist-git \
  google-chrome \
  steam \
  gimp \
  inkscape \
  kdenlive \
  libu2f-host \
  powertop \
  blender \
  audacity \
  curl \
  irssi \
  arandr \
  otf-hack \
  scrot \
  lsof \
  xclip \
  nitrogen \
  python2-gnomekeyring \
  system-config-printer \
  nss-mdns \
  avahi \
  ardour \
  blop \
  amb-plugins \
  swh-plugins \
  fil-plugins \
  g2reverb \
  mcp-plugins \
  pvoc \
  rev-plugins \
  tap-plugins \
  vco-plugins \
  wah-plugins

sudo systemctl enable org.cups.cupsd.service
sudo systemctl start org.cups.cupsd.service
sudo systemctl enable avahi-daemon.service
sudo systemctl start avahi-daemon.service
sudo cp deps/nsswitch.conf /etc/nsswitch.conf
sudo systemctl restart avahi-daemon.service
sudo systemctl restart org.cups.cupsd.service

git config --global user.email "sharms@snowfoundry.com"
git config --global user.name "Steve Harms"

#pacaur -S \
#  infinality-bundle \
#  infinality-bundle-multilib \
#  ttf-ubuntu-font-family-ib \
#  ttf-droid-ib \
#  ttf-noto-fonts-ib \
#  ttf-hack-ibx \
#  ttf-dejavu-ib \
#  jdk8-openjdk-infinality \
pacaur -S numix-circle-icon-theme-git \
  foo2zjs-nightly \
  fonts-meta-base \
  fonts-meta-extended-lt \
  dmenu2 \
  ttf-material-design-icons-git \
  otf-hack \
  otf-font-awesome \
  i3-gaps \
  i3lock \
  light \
  i3ipc-python-git \
  lemonbar-xft-git \
  gvim \
  foo2zjs-nightly
  frei0r-plugins \
  natron \
  natron-plugins \
  openfx-arena
 
mkdir -p $HOME/Repos
cd $HOME/Repos
git clone https://github.com/nana-4/Flat-Plat.git
sudo cp -R Flat-Plat /usr/share/themes/
git clone https://github.com/chriskempson/base16-gnome-terminal.git

systemctl enable gdm.service

echo 'eval "$(rbenv init -)"' >> ~/.bashrc
ssh-keygen -t rsa -b 4096

bash <(curl -fksSL https://raw.github.com/overtone/emacs-live/master/installer/install-emacs-live.sh)

mkdir $HOME/bin
cd $HOME/bin
curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod +x lein
cd
echo "PATH=\$PATH:\$HOME/bin" >> ~/.zshrc
echo "alias ff=\"ssh frostfall\"" >> ~/.zshrc
echo -e "Host frostfall\n  HostName 10.0.0.250\n" >> ~/.ssh/config
echo -e "10.0.0.250\tfrostfall.snowfoundry.net\tfrostfall" | sudo tee --append /etc/hosts
systemctl enable autofs.service
systemctl start autofs.service
sudo umount /var/cache/pacman/pkg
sudo rm -r /var/cache/pacman/pkg
sudo ln -s /net/frostfall/export/pacman/packages /var/cache/pacman/pkg

git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

cd ~/.live-packs/sharms-pack/lib
git clone https://github.com/jaypei/emacs-neotree.git neotree
echo "(add-to-list 'load-path \"/home/sharms/.live-packs/sharms-pack/lib/neotree\")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
" >> ~/.live-packs/sharms-pack/init.el

echo "(set-face-attribute 'default nil
                    :family \"Source Code Pro\"
                    :height 110
                    :weight 'normal
                    :width 'normal)
" >> ~/.live-packs/sharms-pack/init.el

cd
mkdir -p ~/.local/share/gnome-shell
cp -r deps/extensions ~/.local/share/gnome-shell/

# Gnome Extensions Command Line: http://bernaerts.dyndns.org/linux/76-gnome/345-gnome-shell-install-remove-extension-command-line-script
# Emacs default fonts: http://emacs.stackexchange.com/questions/2501/how-can-i-set-default-font-in-emacs
# Bash check environment vars: http://stackoverflow.com/questions/307503/whats-a-concise-way-to-check-that-environment-variables-are-set-in-unix-shellsc
# Bash check directory exists: http://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
# Arch check NTP: http://www.archlinuxuser.com/2013/01/how-to-set-local-time-on-archlinux.html
# Recommend IRC Channels: https://news.ycombinator.com/item?id=7161236
# SASL Freenode config: https://freenode.net/kb/answer/irssi
# IRSSI Setup guide: http://www.antonfagerberg.com/blog/my-perfect-irssi-setup/
# Emacs Live: https://github.com/overtone/emacs-live
# Emacs Neotree: https://github.com/jaypei/emacs-neotree
# Ultimate Vimrc: https://github.com/amix/vimrc

systemctl enable NetworkManager
systemctl start NetworkManager
gsettings set org.gnome.desktop.interface scaling-factor 1
pacaur -S lib32-libpulse lib32-libxrandr lib32-libxtst lib32-gtk2 lib32-libcurl-gnutls steam-native-runtime steam-fonts keepassx2
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
