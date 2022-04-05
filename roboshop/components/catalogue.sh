#!/bin/bash

source components/common.sh

print " Configure YUM Reps"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>LOG_FILE
StatCheck $?

print " Installing NodeJS"
yum install nodejs gcc-c++ -y &>>LOG_FILE
StatCheck $?

print "Adding an User"
useradd ${APP_USER} &>>LOG_FILE
StatCheck $?

print "Download application content"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>LOG_FILE
StatCheck $?

print "Cleaning old files "
rm -rf /home/roboshop/catalogue &>>$LOG_FILE
StatCheck $?

print "Extracting App content"
cd /home/roboshop &>>LOG_FILE && unzip -o /tmp/catalogue.zip &>>LOG_FILE && mv catalogue-main catalogue &>>LOG_FILE
StatCheck $?

print " Installing NPM"
cd /home/roboshop/catalogue &>>LOG_FILE && npm install &>>LOG_FILE
StatCheck $?
