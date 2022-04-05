#!/bin/bash

source components/common.sh

print " Setup YUM repos "
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>LOG_FILE
StatCheck $?

print " Installing Mongodb "
yum install -y mongodb-org &>>LOG_FILE
StatCheck $?

print " Updating Mongodb address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
StatCheck $?

print " Starting Mongodb"
systemctl enable mongod &>>LOG_FILE && systemctl start mongod &>>LOG_FILE
StatCheck $?

print " DownLoading Schema for Mongodb"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>LOG_FILE
StatCheck $?

print "Extracting Schema"
cd /tmp &>>LOG_FILE && unzip mongodb.zip &>>LOG_FILE
StatCheck $?

print "Load Schema"
cd mongodb-main &>>LOG_FILE && mongo < catalogue.js &>>LOG_FILE mongo < users.js &>>LOG_FILE
StatCheck $?



