# /**
#  * @author Son NguyenHong
#  * @email sonnh.uit@gmail.com
#  * @create date 2021-09-17 16:30:46
#  * @modify date 2021-09-17 16:30:46
#  * @desc [description]
#  */

#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PLAIN='\033[0m'

# check root
if [ $(/usr/bin/id -u) -ne 0 ]; then
    printf "${RED}Error: ${PLAIN} This script must be running as root\n"
    exit 1
fi

# sudo without password
addnewUser() {
    local MYUSER='sonnh11'
    local MYPASSWD='123123'
    adduser -p $(openssl passwd -1 $MYPASSWD) $MYUSER
    echo "$MYUSER  ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$MYUSER"
}

checkOSInfo() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_FAMILY=$NAME
    else
        echo "Cannot check OS infomation"
    fi
}

installZSH () {
    local cmd=$1
    $cmd -y install zsh
    $cmd -y install git
    $cmd -y install wget
    $cmd -y install fonts-powerline
    $cmd -y install nano
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
    chsh -s $(which zsh)
    git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    echo "source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
    sed -i '/ZSH_THEME="robbyrussell"/c\ZSH_THEME="agnoster"' ~/.zshrc
    sed -i '/auth       required   pam_shells.so/c\auth       sufficient   pam_shells.so' ~/.zshrc
    zsh

}

main() {
    checkOSInfo
    if [[ $OS_FAMILY == 'Ubuntu' ]]; then
        local cmd='apt-get'
        installZSH $cmd
    elif [[ $OS_FAMILY == 'CentOS Linux' ]]; then
        local cmd='yum'
        installZSH $cmd
    else
        printf "${RED}Error: ${PLAIN} OS is not Ubuntu or CentOS\n"
    fi
    exit 1
    clear
}

addnewUser
main
