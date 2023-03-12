

COMPONENT=mongodb
LOG_FILE=/tmp/${COMPONENT}
source ./common.sh


echo "Setup MongoDB repos."
 curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG_FILE}
statuscheck $?
# ```

echo "Install Mongo & Start Service."

echo "installing mangodb"  
 yum install -y mongodb-org &>>${LOG_FILE}
statuscheck $?
echo "enabling mangodb" 
 systemctl enable mongod &>>${LOG_FILE}
statuscheck $? 
echo "starting mangodb" 
 systemctl start mongod &>>${LOG_FILE}
statuscheck $?
# ```

echo " 1. Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file "

# Config file: `/etc/mongod.conf`
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE

statuscheck $? 
 echo "then restart the service" &>>$LOG_FILE
 systemctl restart mongod
statuscheck $? 




# ```

echo " Every Database needs the schema to be loaded for the application to work."

echo "Download the schema and load it."

 curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
statuscheck $?


cd /tmp
 unzip mongodb.zip statuscheck  &>>$LOG_FILE
statuscheck $?


 cd mongodb-main  &>>$LOG_FILE
statuscheck $?


mongo < catalogue.js  &>>$LOG_FILE
statuscheck $?


 mongo < users.js  &>>$LOG_FILE
statuscheck $?



# ```

# Symbol `<` will take the input from a file and give that input to the command.