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
  echo -e "\e[32m $1 \e[0m"
}
USER_ID=$(id -u)
if [ "$USER_ID" -ne 0]
then
  echo you should run with root user
  exit 1
fi
print "Installing Nginx"
yum install nginx -y
StatCheck $?

print "Downloading Nginx package"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
StatCheck $?

print "Cleaning old Nginx files "
rm -rf /usr/share/nginx/html/*
StatCheck $?

cd /usr/share/nginx/html/

print "Extracting Zip file and Moving the files"
unzip /tmp/frontend.zip && mv frontend-main/* . && mv static/* .
StatCheck $?

print "Updating roboshop configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
StatCheck $?

print "Starting Nginx"
systemctl restart nginx && systemctl enable nginx
StatCheck $?