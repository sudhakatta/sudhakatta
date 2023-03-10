ID=$(id -u)
if [ ID -ne 0 ]
then
echo "you are not running as root user.........it will not get executed"
exit 1
fi


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
 curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip"
 statuscheck $?
 echo "remove old content if it is exists already"

echo "stopping service before removing the content"
systemctl  stop ${COMPONENT}.service
 cd /home/roboshop && rm -rf ${COMPONENT}
 echo "extracting the application"
 unzip /tmp/${COMPONENT}.zip
  statuscheck $?
 mv ${COMPONENT}-main ${COMPONENT}


}

SYSTEMD_SETUP(){

echo "updating the systemd with ip adress of other connections like redis endpoint ,mongodb endpoint"

sed -i -e 's/REDIS_ENDPOINT/10.1.0.6/' -e 's/MONGO_ENDPOINT/10.1.0.5/' -e 's/CATALOGUE_ENDPOINT/10.1.0.8/' -e 's/MONGO_DNSNAME/10.1.0.5/' -e 's/CARTENDPOINT/10.1.0.7/' -e 's/DBHOST/10.1.0.10/' -e 's/CARTHOST/10.1.0.7/' -e 's/USERHOST/10.1.0.9/' -e 's/AMQPHOST/10.1.0.12/' /home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE}
#sed -i -e 's/MONGO_DNSNAME/10.1.0.5/' -e 's/REDIS_ENDPOINT/10.1.0.6/' -e 's/CATALOGUE_ENDPOINT/10.1.0.8/' -e 's/MONGO_ENDPOINT/10.1.0.5/' /home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE}


statuscheck $?



echo "setting up the service to run"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service  
statuscheck $?
echo "Reloading the config from disk"
systemctl daemon-reload
statuscheck $?
echo "Restarting the Service"
 systemctl start ${COMPONENT}
 statuscheck $?
 echo "Enabling the Service"
 systemctl enable ${COMPONENT}
 statuscheck $?

}

statuscheck()
{
if [ $1 -eq 0 ]
then
echo -e status="\e[32 sucess\e[0m"
else
echo -e status="\e[31 failure\e[0m"
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
statuscheck $?
SYSTEMD_SETUP
}
MAVEN()
{
    echo "install maven"
yum install maven -y &>>${LOG_FILE}
statuscheck $?
APP_PREREQ
echo "instaling the dependancies"
cd /home/roboshop
cd ${COMPONENT}
 mvn clean package &>>${LOG_FILE}
 mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar &>>${LOG_FILE}
statuscheck $?
SYSTEMD_SETUP
}
PHYTON()
{
    echo "install python"
    yum install python36 gcc python3-devel -y  &>>${LOG_FILE}
statuscheck $?
APP_PREREQ
echo "Instaling dependencies"
cd /home/roboshop
cd ${payment} 
pip3 install -r requirements.txt &>>${LOG_FILE}
statuscheck $?
SYSTEMD_SETUP
}

GOLANG()
{
    echo "installing golang"
    yum install golang -y &>>${LOG_FILE}
    statuscheck $?
APP_PREREQ

echo "Installing dependencies"
    cd /home/roboshop
    cd ${COMPONENT} 
 go mod init dispatch &>>${LOG_FILE}
 go get &>>${LOG_FILE}
 go build &>>${LOG_FILE}
SYSTEMD_SETUP




echo " Installing golang "
    yum install golang -y &>>${LOG_FILE}
    Statuscheck $?

    APP_PREREQ

    echo " Installing the dependencies "
    cd /home/roboshop
    cd ${COMPONENT}
    #cd /home/${COMPONENT}/
    go mod init dispatch &>>${LOG_FILE}
    Statuscheck $?

    echo "Doing the golang build"
    go get 
    go build &>>${LOG_FILE}
    Statuscheck $?

    SYSTEMD_SETUP
}