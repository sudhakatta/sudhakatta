APP_PREREQ()
{}

SYSTEMD_SETUP(){

}
NODEJS()
{

echo "nodejs code setup"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
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