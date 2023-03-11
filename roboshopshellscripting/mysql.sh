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

