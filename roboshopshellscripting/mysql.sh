COMPONENT=mysql
LOG_FILE=/tmp/${COMPONENT}
source ./common.sh

if [ $# -eq 0 ]
then
echo "you need to provide valid passowrd"
echo "exiting the code"
exit 1;

fi

echo "setup the repo for mysql"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG_FILE}
statuscheck $?
dnf module disable mysql
echo "Install mysql"
 yum install mysql-community-server -y &>>${LOG_FILE}
statuscheck $?
echo "enable & start mysql"

 systemctl enable mysqld &>>${LOG_FILE}
statuscheck $?
 systemctl start mysqld &>>${LOG_FILE}
statuscheck $?

DEFAULT_PASSWORD=$( grep ' A temporary password' temp /var/log/mysqld.log | cut -d " " -f 11)

echo " ALTER USER 'root'@'localhost' IDENTIFIED BY '$1';
FLUSH PRIVILEGES; " > /tmp/set-root-passwd.sql

echo "show databases;" | mysql  -uroot -p${DEFAULT_PASSWORD}
if [ $? -ne 0 ]; then 
echo " change the default password"
mysql  -uroot -p${DEFAULT_PASSWORD} < /tmp/set-root-passwd.sql &>>$LOG_FILE
Statuscheck $?
echo " uninstall plugin validate_password; " | mysql -uroot -p$1 &>>$LOG_FILE
Statuscheck $?
fi 

echo "cleaning up before install"
rm -rf /tmp/mysql.zip

curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>$LOG_FILE
Statuscheck $?

echo "load the schema"
 cd /tmp
 unzip mysql.zip
 cd mysql-main
 mysql -u root -pRoboShop@1 <shipping.sql