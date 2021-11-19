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

#User and key
MYUSER='sonnh11'
MYPASSWD='123123'
MYSSHKEY='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8mhLODwa7qWIOnm1uEmuq4788GMTCX2kcFgCB/UMD87Vm0wtqaBGSy9EwpfUbaWifHtXH+P3JY0vNgxAibQn2j4PDHILkg9zrR81FzTcBCPeBvc+vEqlNWCTtBWAGb19WMMNzfj7DMFxP6aV2H9pgHUkiHhFLOyyC1WnGjeusl6j9lt+9s9G0BOQ0iPFLkRoWFZjYbSBOa1CNJTTQFB+tRh44M2nXhkam3Zn0GtMD27T5jwz6a+8NwhKE1M2uoFCWvTNX0t/R72DkPe3ztjq8Zj5/sL+4E3BLX+OK9eQf1/10v2iDWqGeICx6WwUYlIesr9a4P2Vx7p0usd+cjAHF sonnh11@server1'

# check root
if [ $(/usr/bin/id -u) -ne 0 ]; then
    printf "${RED}Error: ${PLAIN} This script must be running as root\n"
    exit 1
fi

checkOSInfo() {
    clear
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $NAME in
            "Ubuntu")
                OS_FAMILY=1
                ;;
            "CentOS Linux"|"Red Hat Enterprise Linux"|"Amazon Linux")
                OS_FAMILY=2
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

# Add my user to system
addnewUser() {
    if [[ $OS_FAMILY -eq 1 ]]; then
        adduser --disabled-password --gecos "" $MYUSER
        echo $MYUSER:$MYPASSWD | chpasswd
    # else [[ $OS_FAMILY -eq 2 ]]; then
    else
        adduser -p $(openssl passwd -1 $MYPASSWD) $MYUSER
    # else
    #     printf "${YELLOW}Error: ${PLAIN} OS not supported\n"
    #     exit 0
    fi
    
    echo "$MYUSER  ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$MYUSER"
    usermod -aG root "$MYUSER"

    mkdir /home/$MYUSER/.ssh
    chmod 700 /home/$MYUSER/.ssh
    chown $MYUSER:$MYUSER /home/$MYUSER/.ssh
    echo "$MYSSHKEY" > /home/$MYUSER/.ssh/authorized_keys
    chmod 700 /home/$MYUSER/.ssh/authorized_keys
    chown $MYUSER:$MYUSER /home/$MYUSER/.ssh/authorized_keys

}

installLib() {
    local cmd=$1
    $cmd -y install zsh
    $cmd -y install wget
    $cmd -y install fonts-powerline
    $cmd -y install nano
    $cmd -y update
}

installZSH () {
    
    installLib $1
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
    git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    sed -i '/ZSH_THEME="robbyrussell"/c\ZSH_THEME="agnoster"' ~/.zshrc
    echo "source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
    yes | cp -i ~/.zshrc /home/$MYUSER/.zshrc
    cp -avr ~/.oh-my-zsh /home/$MYUSER/.oh-my-zsh

    chown $MYUSER:$MYUSER /home/$MYUSER/.zshrc
    chmod 755 /home/$MYUSER/.zshrc

    chown -R $MYUSER:$MYUSER /home/$MYUSER/.oh-my-zsh
    chmod -R 755 /home/$MYUSER/.oh-my-zsh

    sed -i "/$MYUSER:x:1001:1001/c\\$MYUSER:x:1001:1001::/home/$MYUSER:/usr/bin/zsh" /etc/passwd
    sed -i '/root:x:0:0:root:/c\root:x:0:0:root:/root:/usr/bin/zsh' /etc/passwd

    if [[ $OS_FAMILY -eq 1 ]]; then
        sed -i "/root\/.oh-my-zsh/c\export ZSH=\"/home/$MYUSER/.oh-my-zsh\"" /home/$MYUSER/.zshrc
    fi
}

main() {
    addnewUser
    if [[ $OS_FAMILY -eq 1 ]]; then
        local cmd='apt-get'
        installZSH $cmd
    # else [[ $OS_FAMILY -eq 2 ]]; then
    else
        local cmd='yum'
        installZSH $cmd
    # else
    #     printf "${YELLOW}Error: ${PLAIN} OS not supported\n"
    fi
    exit 1
    printf "${GREEN}Install successfull${PLAIN}\n"
}

checkOSInfo
main
