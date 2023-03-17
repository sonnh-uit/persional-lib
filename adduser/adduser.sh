############################
#   Author: sonnh
#   Date: 14:51 13/03/2023
#   File name: adduser.sh
#   Description: 
#############################

#!/bin/bash

USER='alice' # Input your username here 
PASSWD=''  # Input your password. If not, use random password
PUBLIC_KEY='' # Input your public key

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PLAIN='\033[0m'
PACKAGE_COMMAND=''
SECRET_FILE='secret.txt'

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
            "CentOS Linux"|"Red Hat Enterprise Linux"|"Amazon Linux")
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

    if [ ! -e '/usr/bin/openssl' ];
    then
        $PACKAGE_COMMAND -y install openssl
    fi
}

generate_secret() {
    if [ -z "$PASSWD" ]
    then
        PASSWD="$(echo $RANDOM | md5sum | head -c 20; echo;)"
        echo "Your password is:" "$PASSWD" >> $SECRET_FILE
    fi

    if [ -z "$PUBLIC_KEY" ];
    then
        ssh-keygen -q -t rsa -N '' -f ~/secret <<<y >/dev/null 2>&1
        PUBLIC_KEY=`cat ~/secret.pub`
        echo "Your secret key is below.\n" "$($cat ~/secret)" >>  $SECRET_FILE
    fi
    rm -rf ~/secret secret.txt

}


addnewUser() {
    if [ ! -d "/home/$USER" ]; then
        if [[ $OS_FAMILY -eq 1 ]]; then #ubuntu
            adduser --disabled-password --gecos "" $USER
            echo $USER:$PASSWD | chpasswd
        else #centos and ret hat
            adduser -p $(openssl passwd -1 $PASSWD) $USER
        fi
    else
        printf "${RED}Error: ${PLAIN} Add user fail!\n"
    fi
    
    echo "$USER  ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$USER"
    usermod -aG root "$USER"

    mkdir /home/$USER/.ssh
    chmod 700 /home/$USER/.ssh
    chown $USER:$USER /home/$USER/.ssh
    echo "$PUBLIC_KEY" > /home/$USER/.ssh/authorized_keys
    chmod 700 /home/$USER/.ssh/authorized_keys
    chown $USER:$USER /home/$USER/.ssh/authorized_keys

}

main() {
    OS_check
    generate_secret
    addnewUser

}

main
