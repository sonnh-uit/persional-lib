#!/bin/bash

MYUSER='sonnh11'
MYPASSWD='123123'
MYSSHKEY='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8mhLODwa7qWIOnm1uEmuq4788GMTCX2kcFgCB/UMD87Vm0wtqaBGSy9EwpfUbaWifHtXH+P3JY0vNgxAibQn2j4PDHILkg9zrR81FzTcBCPeBvc+vEqlNWCTtBWAGb19WMMNzfj7DMFxP6aV2H9pgHUkiHhFLOyyC1WnGjeusl6j9lt+9s9G0BOQ0iPFLkRoWFZjYbSBOa1CNJTTQFB+tRh44M2nXhkam3Zn0GtMD27T5jwz6a+8NwhKE1M2uoFCWvTNX0t/R72DkPe3ztjq8Zj5/sL+4E3BLX+OK9eQf1/10v2iDWqGeICx6WwUYlIesr9a4P2Vx7p0usd+cjAHF sonnh11@server1'
MYSQL_ROOT_PASSWD='Aa123456@'

addnewUser() {
    adduser -p $(openssl passwd -1 $MYPASSWD) $MYUSER
    echo "$MYUSER  ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$MYUSER"
    usermod -aG root "$MYUSER"

    mkdir /home/$MYUSER/.ssh
    chmod 700 /home/$MYUSER/.ssh
    chown $MYUSER:$MYUSER /home/$MYUSER/.ssh
    echo "$MYSSHKEY" > /home/$MYUSER/.ssh/authorized_keys
    chmod 700 /home/$MYUSER/.ssh/authorized_keys
    chown $MYUSER:$MYUSER /home/$MYUSER/.ssh/authorized_keys

}

#Install services
enable_service()
{
    systemctl enable httpd
    systemctl enable mysqld
    service httpd restart
    service mysqld restart
}

install_apache()
{
    yum -y install httpd
    yum -y install php php-mysql
    echo "<?php phpinfo (); ?>" >> /var/www/html/info.php
    HOSTNAME=`cat /etc/hostname`
    echo "<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="author" content="SonNH">
    <title>Test page in ec2 insntance</title>
</head>

<body>
    <h1>Wel come to fist website in $HOSTNAME</h1>
</body>

</html>" > /var/www/html/index.html
}


install_mysql()
{
    curl https://dev.mysql.com/downloads/repo/yum/ >> tmp
    rpm_package=`cat tmp | grep "mysql80-community-release-el7" | grep -oP '(?<=\().*(?=\))'`
    rm -f tmp
    wget "https://dev.mysql.com/get/$rpm_package"
    rpm -ivh $rpm_package
    yum -y install mysql-server
    rm -f $rpm_package
    service mysqld start
    password_match=`awk '/A temporary password is generated for/ {a=$0} END{ print a }' /var/log/mysqld.log | awk '{print $(NF)}'`
    mysql -uroot -p$password_match --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWD'; flush privileges;"
    user=root
    password=$MYSQL_ROOT_PASSWD > /root/.my.cnf
}

main()
{
    addnewUser
    install_apache
    install_mysql
    enable_service
}

main