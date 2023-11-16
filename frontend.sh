color="\e[32m"
log_file=/tmp/expense.log
mysql_pass=$1

status_check() {
if [ $? -eq 0 ]; then
      echo -e "\e[34m success \e[0m"
    else
      echo -e "\e[31m failed \e[0m"
      exit
fi
}

echo -e "${color} installing nginx \e[0m"
dnf install nginx -y &>>$log_file
status_check

echo -e "${color} copying expense.conf file \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf
status_check

echo -e "${color} removing the default content of nginx \e[0m"
rm -rf /usr/share/nginx/html/* &>>$log_file
status_check

echo -e "${color} downloading the frontend content \e[0m"
curl -o /tmp/frontend.zip phttps://expense-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
status_check

echo -e "${color} unzipping frontend content \e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$log_file
status_check

echo -e "${color} enabling nginx \e[0m"
systemctl enable nginx &>>$log_file
status_check

echo -e "${color} starting nginx \e[0m"
systemctl start nginx &>>$log_file
status_check


echo -e "${color} restarting nginx \e[0m"
systemctl restart nginx
status_check
