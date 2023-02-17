#!/bin/sh
# set -x
###################################
#
#Author: ironartisan, Date: 2023/2/17
#

###################################


#学号
USER=

# 密码
PASSWD=

# 网关
GATEWAY=10.3.8.211

#命令执行文件路径
CMD_PATH="/usr/bin/curl"

#命令执行参数
CMD_OPTS=""

#执行的程序前缀

CMD="$CMD_PATH $CMD_OPTS"


#初始化psid变量（全局）
psid=0

###################################
#
#为输出文字添加颜色
###################################
## blue to echo
blue(){
    echo -e "\033[35m $1 \033[0m"
}

## green to echo
green(){
    echo -e "\033[32m $1 \033[0m"
}

## Error to Infoing with blink
bred(){
    echo -e "\033[31m\033[01m\033[05m $1 \033[0m"
}

## Error to Infoing with blink
byellow(){
    echo -e "\033[33m\033[01m\033[05m $1 \033[0m"
}


## Error
red(){
    echo -e "\033[31m\033[01m $1 \033[0m"
}

## Info
yellow(){
    echo -e "\033[33m\033[01m $1 \033[0m"
}

###################################
#判断程序是否已联网
###################################
checkpid() {
    ping -c 1 -w 1 www.baidu.com > /dev/null
    if [ $? -eq 0 ];then
        psid=1
    else
        psid=0
    fi
}

###################################
#登录
###################################
login() {
   checkpid
   if [ $psid -ne 0 ]; then
      yellow "================================"
      yellow "Info: You have successfully logged in"
      yellow "================================"
   else
      green  "Logining..."
      $CMD  "http://${GATEWAY}/login" --data "user=${USER}&pass=${PASSWD}" >/dev/null 2>&1 &
      sleep 1
      checkpid
      if [ $psid -ne 0 ]; then
         green "Login Sucess"
      else
         red "Login  Failed"
      fi
   fi
}

###################################
#登出
###################################
logout() {
   checkpid
   if [ $psid -ne 0 ]; then
      $CMD  "http://${GATEWAY}/logout"  >/dev/null 2>&1 &
      green "Logout Sucess"
   else
      yellow "================================"
      yellow "Info: You are not logged in"
      yellow "================================"
   fi
}
###################################
#检查联网状态
###################################
check() {
   checkpid

   if [ $psid -ne 0 ];  then
      green "Info: You have successfully logged in"
   else
      yellow "Info: You are not logged in"
   fi
}

###################################
#读取脚本的第一个参数($1)，进行判断
#参数取值范围：{start|stop|restart|status}
#如参数不在指定范围之内，则打印帮助信息
###################################
case "$1" in
   'login')
      login
      ;;
   'logout')
     logout
     ;;
   'restart')
     logout
     login
     ;;
   'check')
     check
     ;;
  *)
     blue "Usage: $0 {login|logout|check}"
     exit 1
esac
exit 0
# set +x