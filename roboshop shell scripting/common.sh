APP_PREREQ()
{

    echo "valide roboshop already exists or not"
    id roboshop &>>${LOG_FILE}
   

    if [ $? -ne 0 ]
then
useradd roboshop &>>${LOG_FILE}
statuscheck $?
echo "roboshop user added now"

fi


echo "Download ${COMPONENT} component"
 curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip"
 statuscheck $?
 echo "remove old content if it is exists already"


 cd /home/roboshop && rm -rf ${COMPONENT}
 echo "extracting the application"
 unzip /tmp/${COMPONENT}.zip
  statuscheck $?
 mv ${COMPONENT}-main ${COMPONENT}


}

SYSTEMD_SETUP(){

}

statuscheck()
{
if [ $1 -eq 0 ]
then
echo -e status="\e[32sucess\e[0m"
else
echo -e status="\e[31failure\e[0m"
exit 1
fi

}
NODEJS()
{

echo "nodejs code setup"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
statuscheck $? 
# $? 0 sucess, any other number not sucess

echo "Install nodejs"
yum install nodejs -y &>>${LOG_FILE}
statuscheck $?
APP_PREREQ
echo "Install node dependencies"
cd /home/roboshop
cd ${COMPONENT}
echo "Installing npm"
npm install &>>${LOG_FILE}
}
JAVA()
{

}
PHYTON()
{

}

GOLANG()
{

}