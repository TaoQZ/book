#!/bin/bash
###########自定义变量#########
oracle_version="Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production"
oracle_base=/home/oracle/app/oracle
oracle_instance_name=taoqingzhou
oracle_password=taoqingzhou
oracle_unzip=/home/oracle
oracle_log_file=/tmp/oracle_install.log

##########变量################
oracle_home=${oracle_base}/product/11.2.0/db_1
oracle_file_1=/tmp/linux.x64_11gR2_database_1of2.zip
oracle_file_2=/tmp/linux.x64_11gR2_database_2of2.zip
host_name=`hostname`
host_ip=`ip addr | grep inet | grep -v 127 | grep -v inet6 |awk '{print $2}'| grep -Eo "[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}"`


###########函数区#############
#打印输出
function wlog()
{
    content_str=$1
    var_color=$2
    var_curr_timestamp=`date "+%Y-%m-%d %H:%M:%S.%N" | cut -b 1-23`
	content_echo_str=""
	

    ## 判断参数1 是否是空字符串
    if [ "x${content_str}" == "x" ];then
        return
    else
        content_str="[${var_curr_timestamp}] ${content_str}"
    fi
	content_echo_str="${content_str}"

    ## 判断颜色
    if [ "${var_color}" == "green" ];then
        content_echo_str="\033[32m${content_str}\033[0m"
    elif [ "${var_color}" == "yellow" ];then
        content_echo_str="\033[33m${content_str}\033[0m"
    elif [ "${var_color}" == "red" ];then
        content_echo_str="\033[1;41;33m${content_str}\033[0m"
    fi

    ## 打印输出
    echo -e "${content_echo_str}"
	
	echo "${content_str}" >> ${oracle_log_file}
}

#判断交换空间是否足够，不够予以添加
addSwap(){
  swap_zize=`free | grep Swap | awk '{print $2 / 1024 / 1024}'`
  swap_zize=${swap_zize%.*}
  if [ ${swap_zize} -lt 1 ]
	then 
		wlog '交换空间小于1G,正在为您扩充交换空间...'
		dd if=/dev/zero of=/root/swap bs=1024k count=1024 >> ${oracle_log_file} 2>&1
		mkswap /root/swap >> ${oracle_log_file} 2>&1
		swapon /root/swap >> ${oracle_log_file} 2>&1
		echo "/sbin/swapon /root/swap" >> /etc/rc.d/rc.local
  fi
}

#添加oracle11G需要的依赖
installDependence(){
  wlog "正在安装数据库依赖环境..."
  yum install -y gcc make binutils gcc-c++ unzip libXtst-devel compat-libstdc++-33 elfutils-libelf-devel elfutils-libelf-devel-static ksh libaio libaio-devel numactl-devel sysstat unixODBC unixODBC-devel pcre-devel >> ${oracle_log_file} 2>&1
  wlog "数据库依赖环境已完成"
}

#添加oracle用户组以及用户
addOracleUserAndGroup(){
  groupadd oinstall
  groupadd dba
  groupadd oper
  useradd -g oinstall -G dba oracle
  wlog "oracle用户以及用户组已创建，使用oracle用户时自行修改密码"
}

#修改环境变量
modifyEnvironment(){
  cp /etc/sysctl.conf /etc/sysctl.conf.bak_`date "+%Y-%m-%d_%H:%M:%S"`
  echo "fs.aio-max-nr = 1048576" >> /etc/sysctl.conf
  echo "fs.file-max = 6815744" >> /etc/sysctl.conf
  echo "kernel.shmall = 2097152" >> /etc/sysctl.conf
  echo "kernel.shmmax = 536870912" >> /etc/sysctl.conf
  echo "kernel.shmmni = 4096" >> /etc/sysctl.conf
  echo "kernel.sem = 250 32000 100 128" >> /etc/sysctl.conf
  echo "net.ipv4.ip_local_port_range = 9000 65500" >> /etc/sysctl.conf
  echo "net.core.rmem_default = 262144" >> /etc/sysctl.conf
  echo "net.core.rmem_max = 4194304" >> /etc/sysctl.conf
  echo "net.core.wmem_default = 262144" >> /etc/sysctl.conf
  echo "net.core.wmem_max = 1048576" >> /etc/sysctl.conf
  sysctl -p >> ${oracle_log_file} 2>&1
  wlog "/etc/sysctl.conf文件已经备份且修改为oracle官方要求的最小值"
  
  cp /etc/security/limits.conf /etc/security/limits.conf.bak_`date "+%Y-%m-%d_%H:%M:%S"`
  echo "oracle soft nproc 10240" >> /etc/security/limits.conf
  echo "oracle hard nproc 10240" >> /etc/security/limits.conf
  echo "oracle soft nofile 65536" >> /etc/security/limits.conf
  echo "oracle hard nofile 65536" >> /etc/security/limits.conf
  wlog "/etc/security/limits.conf文件已经备份且修改为oracle官方要求的最小值"
  
  cp /etc/pam.d/login /etc/pam.d/login_`date "+%Y-%m-%d_%H:%M:%S"`
  echo "session  required      pam_limits.so" >>  /etc/pam.d/login
  wlog "/etc/pam.d/login已修改，添加session  required      pam_limits.so"
  
  echo "if [ $USER = ""oracle"" ]; then" >>  /etc/profile
  echo "  if [ $SHELL = ""/bin/ksh"" ]; then" >>  /etc/profile
  echo "    ulimit -p 16384" >>  /etc/profile
  echo "    ulimit -n 65536" >>  /etc/profile
  echo "  else" >>  /etc/profile
  echo "    ulimit -u 16384 -n 65536" >>  /etc/profile
  echo "  fi" >>  /etc/profile
  echo "fi" >>  /etc/profile
  source /etc/profile
  wlog "/etc/profile已修改，限制其他用户使用"
}

addOracleP(){
  echo "export TMP=/tmp" >>  /home/oracle/.bash_profile
  echo "export TMPDIR=\$TMP" >>  /home/oracle/.bash_profile
  echo "export ORACLE_BASE=${oracle_base}" >>  /home/oracle/.bash_profile
  echo "export ORACLE_HOME=${oracle_home}" >>  /home/oracle/.bash_profile
  echo "export ORACLE_SID=${oracle_instance_name}" >>  /home/oracle/.bash_profile
  echo "export ORACLE_UNQNAME=${oracle_instance_name}" >>  /home/oracle/.bash_profile
  echo "export ORACLE_TERM=xterm" >>  /home/oracle/.bash_profile
  echo "export PATH=\${ORACLE_HOME}/bin:\$PATH" >>  /home/oracle/.bash_profile
  echo "export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:\$LD_LIBRARY_PATH" >>  /home/oracle/.bash_profile
  source /home/oracle/.bash_profile
  wlog "oracle环境变量已经配置"  
}

replaceValue(){
  strArr=$1
  filePath=$2
  for i in ${strArr[*]}; do
	sed -i "s#^${i%%=*}=.*#${i}#" ${filePath}
  done
}

midifyDbInstall(){
  wlog "正在修改安装文件......"  
  aa[0]="oracle.install.option=INSTALL_DB_SWONLY"
  aa[1]="ORACLE_HOSTNAME=${host_name}"
  aa[2]="UNIX_GROUP_NAME=oinstall"
  aa[3]="INVENTORY_LOCATION=${oracle_base}/oraInventory"
  aa[4]="SELECTED_LANGUAGES=en,zh_CN"
  aa[5]="ORACLE_HOME=${oracle_home}"
  aa[6]="ORACLE_BASE=${oracle_base}"
  aa[7]="oracle.install.db.InstallEdition=EE"
  aa[8]="oracle.install.db.isCustomInstall=false"
  aa[9]="oracle.install.db.EEOptionsSelection=false"
  aa[10]="oracle.install.db.DBA_GROUP=dba"
  aa[11]="oracle.install.db.OPER_GROUP=oinstall"
  aa[12]="oracle.install.db.isRACOneInstall=false"
  aa[13]="oracle.install.db.config.starterdb.type=GENERAL_PURPOSE"
  aa[14]="oracle.install.db.config.starterdb.globalDBName=${oracle_instance_name}"
  aa[15]="oracle.install.db.config.starterdb.SID=${oracle_instance_name}"
  aa[16]="oracle.install.db.config.starterdb.memoryLimit=1024"
  aa[17]="oracle.install.db.config.starterdb.password.ALL=${oracle_password}"
  aa[18]="SECURITY_UPDATES_VIA_MYORACLESUPPORT=false"
  aa[19]="DECLINE_SECURITY_UPDATES=true"  
  replaceValue "${aa[*]}" "${oracle_unzip}/database/response/db_install.rsp"
  wlog "修改安装文文件完毕......"
}
showBar(){
  i=$1
  jj=0
  ((jj=i+3))
  jj=`echo "$i $jj"|awk '{printf "%d\n",$1/$2*100}'`
  msg=$2
  b=`echo "" | sed ":a; s/^/-/; /-\{${jj}\}/b; ta"`
  b="${b}>"
  if [ $msg == "执行中" ]
    then	  
	  printf "[%-101s] %d%% %3s \r" "$b" "$jj" "$msg";
  else
      jj=100
	  b=`echo "" | sed ":a; s/^/-/; /-\{${jj}\}/b; ta"`
	  b="${b}>"
      printf "[%-101s] %d%% %3s \n" "$b" "$jj" "$msg";
  fi
}
installOracle(){
  rm -rf ${oracle_unzip}/database >> ${oracle_log_file} 2>&1
  wlog "开始解压oracle数据库文件..."
  unzip ${oracle_file_1} -d ${oracle_unzip}/ >> ${oracle_log_file} 2>&1
  unzip ${oracle_file_2} -d ${oracle_unzip}/ >> ${oracle_log_file} 2>&1
  chown oracle:oinstall -R ${oracle_unzip}/database
  wlog "oracle数据库文件解压完毕"
  addOracleP
  midifyDbInstall
  wlog "开始安装数据库..."
  su - oracle <<EOF
  cd ${oracle_unzip}/database
  if [ -f oracle_install_log.out ]
    then
      rm oracle_install_log.out
  fi
  nohup ./runInstaller -silent -noconfig -ignorePrereq -responseFile ${oracle_unzip}/database/response/db_install.rsp  >> oracle_install_log.out &
EOF
  
  ii=0
  while true
  do
    sleep 1
	egrep -e "FATAL|Failed" ${oracle_unzip}/database/oracle_install_log.out
	msg=$?
	if [ "$msg" == '0' ]
	  then
		showBar ${ii} "失败"
		exit
	fi
	grep "Successfully Setup Software." ${oracle_unzip}/database/oracle_install_log.out >> ${oracle_log_file} 2>&1
	msg=$?	
	if [ "$msg" == '0' ]
	  then
		showBar 100 "成功"
		wlog "oracle数据库安装成功" "green"
		break
	fi
	showBar ${ii} "执行中"
	((ii=ii+2))
  done
  
  `grep "orainstRoot.sh" ${oracle_unzip}/database/oracle_install_log.out  >> ${oracle_log_file} 2>&1`
  `grep "root.sh" ${oracle_unzip}/database/oracle_install_log.out  >> ${oracle_log_file} 2>&1`
  
  wlog "oracle初始化完成" "green"
}
#安装oracle实例
installIntance(){
  bb[0]="GDBNAME = \"${oracle_instance_name}\""
  bb[1]="SID = \"${oracle_instance_name}\""
  bb[2]="CHARACTERSET = \"ZHS16GBK\""
  bb[3]="NATIONALCHARACTERSET= \"AL16UTF16\""
  bb[4]="MEMORYPERCENTAGE = \"50\""
  bb[5]="DATABASETYPE = \"MULTIPURPOSE\""
  bb[6]="AUTOMATICMEMORYMANAGEMENT = \"TRUE\""
  bb[7]="TOTALMEMORY = \"1024\""
  bb[8]="LISTENERS = \"LISTENER\""
  bb[9]="SYSPASSWORD = \"${oracle_password}\""
  bb[10]="SYSTEMPASSWORD = \"${oracle_password}\""
  for i in "${bb[@]}"; do
    str_trim=`echo ${i%%=*} | sed 's/[ \t]*$//g'`
    sed -i "s/^#${i%%=*}=.*/${i%%=*}=.*/" ${oracle_unzip}/database/response/dbca.rsp
	sed -i "s/^#${str_trim}=.*/${i%%=*}=.*/" ${oracle_unzip}/database/response/dbca.rsp
	sed -i "s#^${i%%=*}=.*#${i}#" ${oracle_unzip}/database/response/dbca.rsp
  done
  su - oracle <<EOF
  cd $ORACLE_HOME/bin
  export DISPLAY=${host_ip}:0.0
  dbca -silent -responsefile  ${oracle_unzip}/database/response/dbca.rsp >> ${oracle_log_file} 2>&1
  netca -silent -responsefile ${oracle_unzip}/database/response/netca.rsp >> ${oracle_log_file} 2>&1
EOF
}

addBootstrap(){
  sed -i "s/^ORACLE_HOME_LISTNER=.*/ORACLE_HOME_LISTNER=\$ORACLE_HOME/" ${oracle_home}/bin/dbstart
  sed -i "s/^ORACLE_HOME_LISTNER=.*/ORACLE_HOME_LISTNER=\$ORACLE_HOME/" ${oracle_home}/bin/dbshut
  rm -rf /etc/oratab 
  echo "${oracle_instance_name}:${oracle_home}:Y" >>  /etc/oratab
  cat >>/etc/rc.d/init.d/oracle<<EOF
#!/bin/bash
# whoami # root 
# chkconfig: 345 51 49  
# description: starts the oracle dabasedeamons 
# 
ORACLE_HOME=${oracle_home}
ORACLE_OWNER=oracle 
ORACLE_DESC="Oracle 11g" 
case "\$1" in 
'start') 
echo -n \"Starting \${ORACLE_DESC}:\" 
runuser - \$ORACLE_OWNER -c '\$ORACLE_HOME/bin/lsnrctl start' 
runuser - \$ORACLE_OWNER -c '\$ORACLE_HOME/bin/dbstart' 
runuser - \$ORACLE_OWNER -c '\$ORACLE_HOME/bin/emctl start dbconsole' 
touch \${ORACLE_LOCK} 
echo 
;; 
'stop') 
echo -n "shutting down \${ORACLE_DESC}: " 
runuser - \$ORACLE_OWNER -c '\$ORACLE_HOME/bin/lsnrctl stop' 
runuser - \$ORACLE_OWNER -c '\$ORACLE_HOME/bin/dbshut' 
rm -f \${ORACLE_LOCK} 
echo  
;; 
'restart') 
echo -n "restarting \${ORACLE_DESC}:" 
\$0 stop 
\$0 start 
echo 
;; 
*)  
echo "usage: \$0 { start | stop | restart }" 
exit 1 
esac 
exit 0
EOF
  chmod 755 /etc/rc.d/init.d/oracle
  chkconfig --add oracle
}
main(){
  clear
  cat /dev/null > ${oracle_log_file}
  chmod 777 ${oracle_log_file}
  wlog "开始为您一键安装oracle数据库，请确认一下信息" "green"
  wlog "Oracle版本号：${oracle_version}"
  wlog "Oracle主目录：${oracle_base}"
  wlog "Oracle安装目录：${oracle_home}"
  wlog "Oracle数据库实例名称：${oracle_instance_name}"
  wlog "Oracle数据库系统用户初始密码：${oracle_password}"
  wlog "Oracle数据库解压目录：${oracle_unzip}"
  wlog "安装详细日志文件：${oracle_log_file}"
  wlog "确认以此参数安装，请输入Y，开始安装，修改参数请按其他任意键结束安装:" "red"
  read -t 10 confirm_str
  if [ "$confirm_str" != 'y' ] && [ "$confirm_str" != 'Y' ];
    then
	  echo ""
	  wlog "一键安装oracle数据库已停止，您可以再修改完参数后再次执行。" "red"
	  exit
  fi
  if [ $(id -u) != "0" ];
    then 
      wlog "Oracle数据库安装需要以root用户执行!" "red"
    exit
  fi
  
  if [ ! -f ${oracle_file_1} ] || [ ! -f ${oracle_file_2} ];
    then 
      wlog "Oracle数据库文件不存在!" "red"
      exit 
  fi
  wlog "#########开始初始化安装环境#########" "green"
  echo "${host_ip} ${host_name}" >> /etc/hosts
  sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config 
  setenforce 0
  wlog "已关闭selinux"

  installDependence

  modifyEnvironment
  
  addSwap
  
  addOracleUserAndGroup
  
  wlog "#########开始安装oracle数据库#########" "green"
  installOracle
  
  installIntance
  wlog "oracle数据库实例安装完成！" "green"
  
  addBootstrap
  wlog "已为您添加自启动脚本..." "green"
  
  wlog "安装程序已全部结束，请留意防火墙状态并尝试连接数据库进行测试，如有问题欢迎进行反馈交流" "red"
  wlog "关闭防火墙命令：    systemctl stop firewalld" "green"
  wlog "关闭数据库命令：    service oracle stop" "green"
  wlog "开启数据库命令：    service oracle start" "green"
  wlog "重启数据库命令：    service oracle restart" "green"
  wlog "您的数据库连接地址：${host_ip}:1521/${oracle_instance_name}" "green"
  wlog "管理员用户名：      system" "green"
  wlog "初始密码：          ${oracle_password}" "green"
  wlog "创建新用户命令：    CREATE USER {用户名} IDENTIFIED BY {密码}" "green"
  
}

main
