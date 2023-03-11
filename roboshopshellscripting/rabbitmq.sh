
COMPONENT=rabbitmq
LOG_FILE=/tmp/${COMPONENT}
source ./common.sh
echo "downloading relang repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>$LOG_FILE

statuscheck $?
echo "Installing erlang repo"
yum install erlang -y &>>$LOG_FILE

statuscheck $?

echo "setting up yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG_FILE
statuscheck $?

echo "instal rabittmq"
yum install rabbitmq-server -y  &>>$LOG_FILE
statuscheck $?
echo "enable rabbitmq"

systemctl enable rabbitmq-server 
statuscheck $?
echo "start rabbitmq"
 systemctl start rabbitmq-server
 statuscheck $?
rabbitmqctl list_users | grep -i roboshop &>>$LOG_FILE
if [ $? ne 0 ]; then 
    echo "adding roboshop user to rabbitmq"
    rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
    Statuscheck $?
fi

echo " set roboshop user as admin"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG_FILE
Statuscheck $?
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
Statuscheck $?