
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
if [ "$USER_ID" -ne 0 ]
then
  echo you should run with root user
  exit 1
fi

APP_USER=roboshop

NODEJS(){
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
  curl -f -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>LOG_FILE
  StatCheck $?

  print "Cleaning old files "
  rm -rf /home/${APP_USER}/${COMPONENT} &>>$LOG_FILE
  StatCheck $?

  print "Extracting App content"
  cd /home/${APP_USER} &>>LOG_FILE && unzip -o /tmp/${COMPONENT}.zip &>>LOG_FILE && mv ${COMPONENT}-main ${COMPONENT} &>>LOG_FILE
  StatCheck $?

  print " Installing NPM"
  cd /home/${APP_USER}/${COMPONENT} &>>LOG_FILE && npm install &>>LOG_FILE
  StatCheck $?

  print "Set Up Systemd Service"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>LOG_FILE
  StatCheck $?

  print " Moving Systemd File and Restarting "
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>LOG_FILE && systemctl daemon-reload &>>LOG_FILE && systemctl start ${COMPONENT} &>>LOG_FILE && systemctl enable ${COMPONENT} &>>LOG_FILE
  StatCheck $?

}