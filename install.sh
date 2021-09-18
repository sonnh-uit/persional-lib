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

MYUSER='sonnh11'
MYPASSWD='123123'

# sudo without password
addnewUser() {
    adduser -p $(openssl passwd -1 $MYPASSWD) $MYUSER
    echo "$MYUSER  ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$MYUSER"
    usermod -aG root $MYUSER
}

checkOSInfo() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_FAMILY=$NAME
    else
        echo "Cannot check OS infomation"
    fi
}

installLib() {
    local cmd=$1
    $cmd -y install zsh
    $cmd -y install git
    $cmd -y install wget
    $cmd -y install fonts-powerline
    $cmd -y install nano
}

installZSH () {
    installLib $1
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
    git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    sed -i '/ZSH_THEME="robbyrussell"/c\ZSH_THEME="agnoster"' ~/.zshrc
    echo "source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
    cp -avr ~/.oh-my-zsh /home/$MYUSER/.oh-my-zsh
    chown -R $MYUSER:$MYUSER /home/$MYUSER/.oh-my-zsh
    chmod -R 755 /home/$MYUSER/.oh-my-zsh

    yes | cp -i ~/.zshrc /home/$MYUSER/.zshrc
    chown $MYUSER:$MYUSER /home/$MYUSER/.zshrc
    chmod 755 /home/$MYUSER/.zshrc
    
    sed -i "/$MYUSER:x:1001:1001::/c\\$MYUSER:x:1001:1001::/home/$MYUSER:/usr/bin/zsh" /etc/passwd
    sed -i '/root:x:0:0:root:/c\root:x:0:0:root:/root:/usr/bin/zsh' /etc/passwd
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
