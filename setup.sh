#!/bin/bash

# Export the path to this directory for later use in the script
export LINKDOT=$PWD

sudo pacman -S  go nextcloud-client gvim scrot htop arc-gtk-theme firefox sxhkd zathura-pdf-mupdf \
		xclip gnome-keyring xfce4-notifyd xsel xdotool xorg-server xorg-xinit xorg-xrdb \ 
		xorg-xprop xdo pulseaudio-alsa exa pavucontrol tmux bash-completion pamixer \
		pulseaudio fzf cmus bspwm feh git openssh slock ttf-roboto ttf-roboto-mono dash

sudo ln -sfT dash /usr/bin/sh

mkdir -p ~/.config ~/.builds /storage/Music /storage/Images /storage/Downloads /storage/steamlibrary/

ln -sf /storage/Downloads $HOME/
ln -sf /storage/Music $HOME/
ln -sf /storage/Images $HOME/

git clone https://aur.archlinux.org/yay.git ~/.builds/yay
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/horst3180/arc-icon-theme --depth 1 ~/.builds/arc-icon-theme
git clone https://github.com/alchemistswater/aw_dmenu ~/.builds/aw_dmenu

cd ~/.builds/yay
makepkg -si

cd ~/.builds/arc-icon-theme
./autogen.sh --prefix=/usr
sudo make install

cd ~/.builds/aw_dmenu
make
sudo make install

yay -S  picom pfetch-git moka-icon-theme lxappearance sox imagemagick i3lock \
	profile-sync-daemon ttf-font-awesome lemonbar-xft-git st-luke-git

cd ~

read -p "-- Install gaming goodness? May take a minute. [y/N] " yna
case $yna in
            [Yy]* ) yay -S steam steam-native-runtime lib32-libpulse \
		    lib32-alsa-plugins \
                    lutris lutris-wine-meta itch
		    mv $HOME/.steam/steam/steam /storage/steamlibrary/
		    mv $HOME/.steam/steam/steamapps /storage/steamlibrary/
		    ln -sf /storage/steamlibrary/* $HOME/.steam/steam/
                    ;;
                        * ) echo "-- skipping";;
esac

read -p "-- Install communication goodness? May take a minute. [y/N] " yna
case $yna in
            [Yy]* ) yay -S telegram-desktop pulse-sms \
                    ;;
                        * ) echo "-- skipping";;
esac

cd ~
ln -sf $LINKDOT/home/.* /home/$USER/

cd ~/.config
ln -sf $LINKDOT/config/* /home/$USER/.config/

cd /usr/bin
sudo ln -sf $LINKDOT/scripts/* /usr/bin/

systemctl --user enable psd

cd ~

su -c 'cat > /usr/share/dbus-1/services/org.freedesktop.Notifications.service << "EOF"
[D-BUS Service]
Name=org.freedesktop.Notifications
Exec=/usr/lib/xfce4/notifyd/xfce4-notifyd
EOF'

echo "-- Installation Complete! Restart the computer."
