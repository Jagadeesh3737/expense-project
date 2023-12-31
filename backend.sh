source common.sh
mysql_pass=$1

echo -e "${color} disabling nodejs \e[0m"
dnf module disable nodejs -y &>>$log_file
status_check


echo -e "${color} enabling nodejs \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
status_check

echo -e "${color} installing nodejs \e[0m"
dnf install nodejs -y &>>$log_file
status_check

echo -e "${color} copying the backend.service \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
status_check

if [ $? -ne 0 ]; then
   echo -e "${color} adding user \e[0m"
   useradd expense
   status_check
fi


if [ ! -d /app ]; then
  echo -e "${color} making directory \e[0m"
  mkdir /app &>>$log_file
  status_check
fi

cd /app
echo -e "${color} npm installing \e[0m"
npm install &>>$log_file
status_check


echo -e "${color} downloading the backend application code \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
status_check


cd /app
echo -e "${color} unzipping the backend content \e[0m"
unzip -o /tmp/backend.zip &>>$log_file
status_check

echo -e "${color} reloading system \e[0m"
systemctl daemon-reload
status_check

echo -e "${color} enabling backend service \e[0m"
systemctl enable backend
status_check

echo -e "${color} starting backend service \e[0m"
systemctl start backend
status_check

echo -e "${color} installing mysql client \e[0m"
dnf install mysql -y &>>$log_file
status_check

echo -e "${color} loading schema \e[0"
mysql -h mysq-dev.devops76.online -uroot -p$mysql_pass < /app/schema/backend.sql &>>$log_file
status_check




