

COMPONENT=frontend
LOG_FILE=/tmp/${COMPONENT}
source ./common.sh



echo "Let's download the HTDOCS content and deploy under the Nginx path."


curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>${LOG_FILE}
statuscheck $?



echo "Deploy the downloaded content in Nginx Default Location."


 cd /usr/share/nginx/html
  rm -rf *
unzip /tmp/frontend.zip
 mv frontend-main/static/* .
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}
statuscheck $?

echo " Updating the systemD service file with DNS name"
sed -i -e '/catalogue/ s/localhost/10.1.0.8/'  /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}
Statuscheck $?
sed -i -e '/user/ s/localhost/10.1.0.9/'  /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}
Statuscheck $?
sed -i -e '/cart/ s/localhost/10.1.0.7/'  /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}
Statuscheck $?
sed -i -e '/shipping/ s/localhost/10.1.0.11/'  /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}
Statuscheck $?
sed -i -e '/payment/ s/localhost/10.1.0.13/'  /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}
Statuscheck $?

echo "Finally restart the service once to effect the changes"

systemctl restart nginx &>>${LOG_FILE}
Statuscheck $?

Finally restart the service once to effect the changes.

