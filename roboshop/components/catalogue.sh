#!/bin/bash

source components/common.sh

print " Configure YUM Reps"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>LOG_FILE
StatCheck $?

print " Installing NodeJS"
yum install nodejs gcc-c++ -y &>>LOG_FILE
StatCheck $?

print "Adding an User"
id ${APP_USER} &>>LOG_FILE
if [ $? -ne 0 ]
then
useradd ${APP_USER} &>>LOG_FILE
fi
StatCheck $?

print "Download application content"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>LOG_FILE
StatCheck $?

print "Cleaning old files "
rm -rf /home/${APP_USER}/catalogue &>>$LOG_FILE
StatCheck $?

print "Extracting App content"
cd /home/${APP_USER} &>>LOG_FILE && unzip -o /tmp/catalogue.zip &>>LOG_FILE && mv catalogue-main catalogue &>>LOG_FILE
StatCheck $?

print " Installing NPM"
cd /home/${APP_USER}/catalogue &>>LOG_FILE && npm install &>>LOG_FILE
StatCheck $?

print "Set Up Systemd Service"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>LOG_FILE
StatCheck $?

print " Moving Systemd File and Restarting Catalogue"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>LOG_FILE && systemctl daemon-reload &>>LOG_FILE && systemctl start catalogue &>>LOG_FILE && systemctl enable catalogue &>>LOG_FILE
StatCheck $?
