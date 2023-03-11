# dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
# dnf module enable redis:remi-6.2 -y
# yum install redis -y 
 #Update the bind from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf
 # systemctl enable redis
# systemctl start redis

COMPONENT=redis
LOG_FILE=/tmp/${COMPONENT}

source ./common.sh
echo "installing redis repo"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${LOG_FILE}
statuscheck $?
echo "installing redis"
dnf install redis -y &>>${LOG_FILE}
statuscheck $?

echo "updating the bind 127.0.0.1 to 0.0.0.0"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/${COMPONENT}.conf &>>${LOG_FILE}

statuscheck $?
echo "enable redis"
systemctl enable redis
echo "starting  redis"
systemctl start redis

