color="\e[32m"
log_file=/tmp/expense.log
status_check() {
if [ $? -eq 0 ]; then
      echo -e "\e[34m success \e[0m"
    else
      echo -e "\e[31m failed \e[0m"
fi
}


echo -e "${color} installing nginx \e[0m"
dnf install nginx -y &>>$log_log_file
status_check




