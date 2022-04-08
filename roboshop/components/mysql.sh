#!/bin/bash

source components/common.sh

 print "Creating YUM Repos"
 curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>LOG_FILE
 StatCheck $?

print "Installing MySQL"
yum install mysql-community-server -y &>>LOG_FILE
StatCheck $?

print "Starting MySQL"
systemctl enable mysqld &>>LOG_FILE &&systemctl start mysqld &>>LOG_FILE
StatCheck $?
echo " SET PASSWORD FOR 'root'@'localhost' = PASSWORD('Roboshop@1')"; >/tmp/rootpass.sql
DEFAULT_ROOT_PASS=${grep 'temorary password' /var/log/mysqld.log} | awk '{ print $NF }'
mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASS}" </tmp/rootpass.sql


#```bash
## mysql_secure_installation
#```
#
#1. You can check the new password working or not using the following command in MySQL
#
#First lets connect to MySQL
#
#```bash
## mysql -uroot -pRoboShop@1
#```
#
#Once after login to MySQL prompt then run this SQL Command.
#
#```sql
#> uninstall plugin validate_password;
#```
#
### **Setup Needed for Application.**
#
#As per the architecture diagram, MySQL is needed by
#
#- Shipping Service
#
#So we need to load that schema into the database, So those applications will detect them and run accordingly.
#
#To download schema, Use the following command
#
#```bash
## curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#```
#
#Load the schema for Services.
#
#```bash
## cd /tmp
## unzip mysql.zip
## cd mysql-main
## mysql -u root -pRoboShop@1 <shipping.sql
#```