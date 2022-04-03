#!/bin/bash

StatCheck(){
  if [ $1 -eq 0 ]; then
              echo -e "\e[34mSUCCESS\e[0m"
            else
              echo -e "\e[31mFAILURE\e[0m"
              exit 1
            fi
            }
USER_ID=$(id -u)
if [ "$USER_ID" -ne 0]
then
  echo you should run with root user
  exit 1
fi
echo -e "\e[32mInstalling Nginx\e[0m"
yum install nginx -y
StatCheck $?

echo -e "\e[33mDownloading Nginx package \e[0m"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
StatCheck $?

echo -e "\e[31mCleaning old Nginx files and uzipping new files\e[0m"
StatCheck $?
rm -rf /usr/share/nginx/html/*
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip

mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[32mStarting Nginx\e[0m"
systemctl restart nginx
systemctl enable nginx
StatCheck $?