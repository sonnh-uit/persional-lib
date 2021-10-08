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

#My user and passs
MYUSER='sonnh11'
MYPASSWD='123123'

# check root
if [ $(/usr/bin/id -u) -ne 0 ]; then
    printf "${RED}Error: ${PLAIN} This script must be running as root\n"
    exit 1
fi

checkOSInfo() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_FAMILY=$NAME
    else
        echo "Cannot check OS infomation"
    fi
}

# sudo without password
addnewUser() {
    if [[ $OS_FAMILY == 'Ubuntu' ]]; then
        adduser --disabled-password --gecos "" $MYUSER
        echo $MYUSER:$MYPASSWD | chpasswd
    elif [[ $OS_FAMILY == 'CentOS Linux' ]]; then
        adduser -p $(openssl passwd -1 $MYPASSWD) $MYUSER
    else
        printf "${RED}Error: ${PLAIN} OS is not Ubuntu or CentOS\n"
        exit 0
    fi
    
    echo "$MYUSER  ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$MYUSER"
    usermod -aG root "$MYUSER"
}



installLib() {
    local cmd=$1
    $cmd -y install zsh
    $cmd -y install git
    $cmd -y install wget
    $cmd -y install fonts-powerline
    $cmd -y install nano
    $cmd -y update
}

ISubuntu () {
    su $MYUSER -c "wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh"
    su $MYUSER -c "git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    su $MYUSER -c "sed -i '/ZSH_THEME="robbyrussell"/c\ZSH_THEME="agnoster"' ~/.zshrc"
    su $MYUSER -c "echo "source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc"

    su $MYUSER -c "yes | cp -i ~/.zshrc /root/.zshrc"
    su $MYUSER -c "cp -avr ~/.oh-my-zsh /root/.oh-my-zsh"

    chown root:root /root/.zshrc
    chmod 755 /root/.zshrc

    chown -R root:root /root/.oh-my-zsh
    chmod -R 755 /root/.oh-my-zsh
}

installZSH () {
    
    installLib $1
    if [[ $OS_FAMILY == 'Ubuntu' ]]; then
        ISubuntu
    else 
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
    fi

    sed -i "/$MYUSER:x:1001:1001/c\\$MYUSER:x:1001:1001::/home/$MYUSER:/usr/bin/zsh" /etc/passwd
    sed -i '/root:x:0:0:root:/c\root:x:0:0:root:/root:/usr/bin/zsh' /etc/passwd
}



main() {
    addnewUser
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

checkOSInfo
main
