source common.sh

echo -e "${color} disabling mysql \e[0m"
dnf module disable mysql -y &>>$log_file
status_check

echo -e "${color} copying mysql.repo \e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
status_check


echo -e "${color}  installing mysql \e[0m"
dnf install mysql-community-server -y &>>$log_file
status_check


echo -e "${color} enabling mysql \e[0m"
systemctl enable mysqld &>>$log_file
status_check


echo -e "${color} start mysql \e[0m"
systemctl start mysqld &>>$log_file
status_check


echo -e "${color} setting password \e[0m"
mysql_secure_installation --set-root-pass ${mysql_pass} &>>$log_file
status_check

