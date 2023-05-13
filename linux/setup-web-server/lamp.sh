# **********************************************
# *  Author : sonnh
# *  Created On : Sat Jan 08 2022
# *  File : lamp.sh
# ***********************************************
#!/bin/bash


#var
MYSQL_ROOT_PASSWD='Aa123456@'


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
    install_apache
    install_mysql
    enable_service
}

main
