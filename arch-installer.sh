#!/bin/zsh

# Colors
BLACK='\e[30m'
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
PURPLE='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'
NC='\e[0m'

# Check distro
if [ `lsb-release | grep ID | cut -d"=" -f2` != Anarchy ]; then
	echo -e "\n${RED}[!] Your distro is not supported\n${NC}"
	exit 1
fi

# Check root
if [ "$(id -u)" == 0 ]; then
	echo -e "\n${RED}[!] Do not use this script with sudo\n${NC}"
	exit 1
fi

echo -e "${CYAN}[>] Press ENTER to continue, CTRL+C to abort.${NC}"
read INPUT
echo ""


sudo pacman -Sy
sudo pacman -Syu

sudo pacman -S \
		aircrack-ng \
		android-tools \
		apache \
		arp-scan \
		bettercap \
		curl \
		dnsmasq \
		docker \
		dsniff \
		encfs \
		filezilla \
		firefox \
		firefox-i18n-es-cl \
		gimp \
		git \
		hexchat \
		hostapd \
		htop \
		hydra \
		iw \
		libreoffice-fresh \
		libreoffice-fresh-es \
		macchanger \
		masscan \
		mdk3 \
		metasploit \
		nmap \
		net-tools \
		obs-studio \
		openssh \
		openvpn \
		pixiewps \
		php \
		postgresql \
		python-pip \
		python2-pip \
		reaver \
		scapy \
		sqlmap \
		tcpdump \
		telegram-desktop \
		terminator \
		testdisk \
		thefuck \
		tmux \
		tor \
		transmission-gtk \
		tree \
		vim \
		vlc \
		wireshark-gtk \
		whois \
		zeal;

yaourt -Syu
yaourt -S crunch
yaourt -S etcher
yaourt -S sublime-text-dev
yaourt -S weevely
sudo pip2 install pyyaml # for weevely

# fix wifi
sudo pacman -S gnome-keyring

# oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.zshrc ~/.zshrc.orig
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# set alias grep color
echo "alias grep='grep --color=auto '" >> ~/.zshrc

# set alias thefuck
echo "eval \$(thefuck --alias)\n# You can use whatever you want as an alias, like for Mondays:\neval \$(thefuck --alias FUCK)\n" >> ~/.zshrc
source ~/.zshrc

# Wireshark remove warning
sudo mkdir -p /root/.wireshark/
sudo sh -c 'echo "privs.warn_if_elevated: FALSE" > /root/.wireshark/recent_common'
sudo mv -f /usr/share/wireshark/init.lua{,.disabled}

mkdir arsenal
cd arsenal

# install from git

# install theharvester
git clone https://github.com/laramies/theHarvester

# install dirsearch
git clone https://github.com/maurosoria/dirsearch

# install kickthemout
git clone https://github.com/k4m4/kickthemout
cd kickthemout
sudo pip install -r requirements.txt
cd && cd arsenal

# install sublist3r
git clone https://github.com/aboul3la/Sublist3r
cd Sublist3r
sudo pip install -r requirements.txt
cd && cd arsenal

cd

# fix terminal xfce4
sed -i "s/MiscMenubarDefault=FALSE/MiscMenubarDefault=TRUE/g" ~/.config/xfce4/terminal/terminalrc
source ~/.config/xfce4/terminal/terminalrc

# install nano-highlight
git clone git://github.com/serialhex/nano-highlight ~/.nano
echo include ~/.nano/* > ~/.nanorc

# install kvm
#if [ `LC_ALL=C lscpu | grep Virtualization | awk '{print $2}'` == "VT-x"]; then
#fi

# fix ifaces
sudo sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/g' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# network manager patch
echo <<EOF > NetworkManager.conf
[main]
plugins=ifupdown,keyfile,ofono
dns=dnsmasq

[ifupdown]
managed=false

[keyfile]
unmanaged-devices=interface-name:wlan1
EOF
sudo mv NetworkManager.conf /etc/NetworkManager/

echo -e "${CYAN}[>] Press ENTER to reboot, CTRL+C to abort.${NC}"
read INPUT
echo ""
# reboot
sudo reboot
