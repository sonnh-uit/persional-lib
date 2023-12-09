############################
#   Author: sonnh
#   Date: 14:20 14/03/2023
#   File name: zsh_agnoster.sh
#   Description:
#############################

#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PLAIN='\033[0m'

USER_NAME='sonnh11'
PACKAGE_COMMAND=''
ZSH_LINK='https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh'
ZSH_AUTOSUGGESTIONS='https://github.com/zsh-users/zsh-autosuggestions'

# check root
if [ $(/usr/bin/id -u) -ne 0 ]; then
    printf "${RED}Error: ${PLAIN} This script must be running as root\n"
    exit 1
fi

OS_check() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $NAME in
        "Ubuntu")
            OS_FAMILY=1 #define a variable for OS family
            PACKAGE_COMMAND="apt-get"
            ;;
        "CentOS Linux" | "Red Hat Enterprise Linux" | "Amazon Linux")
            OS_FAMILY=2
            PACKAGE_COMMAND="yum"
            ;;
        *)
            printf "${YELLOW}Error: ${PLAIN} OS not supported\n"
            exit 1
            ;;
        esac
    else
        printf "${RED}Error: ${PLAIN} Cannot check OS information\n"
        exit 1
    fi
}

installLib() {
    $PACKAGE_COMMAND -y install zsh
    $PACKAGE_COMMAND -y install wget
    $PACKAGE_COMMAND -y install fonts-powerline
    $PACKAGE_COMMAND -y install nano
    $PACKAGE_COMMAND -y update
}

installZSH() {

    wget $ZSH_LINK -O - | zsh
    git clone $ZSH_AUTOSUGGESTIONS ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    sed -i '/ZSH_THEME="robbyrussell"/c\ZSH_THEME="agnoster"' ~/.zshrc
    wget https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark -P ~
    mv ~/dircolors.ansi-dark ~/.dircolors
    echo "source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
    echo "eval `dircolors ~/.dircolors`" >> ~/.zshrc
    yes | cp -i ~/.zshrc /home/$USER_NAME/.zshrc
    yes | cp -i ~/.dircolors /home/$USER_NAME/.dircolors
    cp -avr ~/.oh-my-zsh /home/$USER_NAME/.oh-my-zsh
    

    chown $USER_NAME:$USER_NAME /home/$USER_NAME/.zshrc
    chmod 755 /home/$USER_NAME/.zshrc

    chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.oh-my-zsh
    chmod -R 755 /home/$USER_NAME/.oh-my-zsh

    sed -i "s/$USER_NAME:\/bin\/bash/$USER_NAME:\/usr\/bin\/zsh/g" /etc/passwd
    sed -i '/root:x:0:0:root:/c\root:x:0:0:root:/root:/usr/bin/zsh' /etc/passwd

    if [[ $OS_FAMILY -eq 1 ]]; then
        sed -i "/root\/.oh-my-zsh/c\export ZSH=\"/home/$USER_NAME/.oh-my-zsh\"" /home/$USER_NAME/.zshrc
    fi

}

main() {
    OS_check
    installLib
    installZSH
}

main


# if in window, must install Cascadia  font. You can follow in https://www.ifconfig.it/hugo/2021/01/zsh-in-wsl-with-agnoster-theme/