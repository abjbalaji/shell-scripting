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

print " Setup YUM repos "
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>LOG_FILE
StatCheck $?
print " Installing Mongodb "
yum install -y mongodb-org &>>LOG_FILE
StatCheck $?
print " Starting Mongodb"
systemctl enable mongod &>>LOG_FILE && systemctl start mongod &>>LOG_FILE
StatCheck $?

