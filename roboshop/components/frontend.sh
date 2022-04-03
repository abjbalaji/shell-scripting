#!/bin/bash

StatCheck(){
  if [ $1 -eq 0 ]; then
              echo -e "\e[34mSUCCESS\e[0m"
            else
              echo -e "\e[31mFAILURE\e[0m"
              exit 1
            fi
            }
print(){
  echo -e "\n............$1..........." &>>$LOG_FILE
  echo -e "\e[32m $1 \e[0m"
}
LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE
USER_ID=$(id -u)
if [ "$USER_ID" -ne 0]
then
  echo you should run with root user
  exit 1
fi
print "Installing Nginx"
yum install nginx -y &>>$LOG_FILE
StatCheck $?

print "Downloading Nginx package"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
StatCheck $?

print "Cleaning old Nginx files "
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
StatCheck $?

cd /usr/share/nginx/html/ &>>$LOG_FILE

print "Extracting Zip file and Moving the files"
unzip /tmp/frontend.zip &>>$LOG_FILE && mv frontend-main/* . &>>$LOG_FILE && mv static/* . &>>$LOG_FILE
StatCheck $?

print "Updating roboshop configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
StatCheck $?

print "Starting Nginx"
systemctl restart nginx &>>$LOG_FILE && systemctl enable nginx &>>$LOG_FILE
StatCheck $?