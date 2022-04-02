#!/bin/bash
echo -e "\e[32mInstalling Nginx\e[0m"
yum install nginx -y

echo -e "\e[33mDownloading Nginx package \e[0m"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

echo -e "\e[31mCleaning old Nginx files and uzipping new files\e[0m"
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

