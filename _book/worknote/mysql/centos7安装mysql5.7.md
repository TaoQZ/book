# Centos7安装mysql5.7

## 1.添加mysql yum仓库

```bash
#下载rpm包
wget https://repo.mysql.com//mysql80-community-release-el7-3.noarch.rpm
#安装rpm包获得yum仓库
rpm -Uvh mysql80-community-release-el7-3.noarch.rpm
```

## 2.选择发行版

```bash
#修改/etc/yum.repos.d/mysql-community.repo配置文件，启用你想安装的mysql版本，这里我们选择mysql5.7
vi /etc/yum.repos.d/mysql-community.repo
```

![image-20201107105140073](./centos7安装mysql5.7.assets\image-20201107105140073.png)

```bash
# 验证是否mysql5.7已启用
yum repolist enabled | grep mysql
```

## 3.安装mysql

```bash
#安装mysql
yum install mysql-community-server
```

## 4.启动mysql

```bash
#启动mysql
systemctl start mysqld.service
#检查状态
systemctl status mysqld.service
```

![image-20201107101135348](./centos7安装mysql5.7.assets\image-20201107101135348.png)

## 5.创建临时密码并登录

```bash
#找到临时密码
grep 'temporary password' /var/log/mysqld.log
#输入以下命令，用上面的密码登陆mysql
mysql -uroot -p
```

![image-20201107101202764](./centos7安装mysql5.7.assets\image-20201107101202764.png)

## 6.修改密码

**注意，这里的密码至少包含一位数字，一位大写字母，一位特殊符号，总长度大于8个字符**

```bash
--修改密码
ALTER USER 'root'@'localhost' IDENTIFIED BY '你的新密码';
```

## 7.开放端口

如果时阿里云在安全组开放端口

```bash
#打开3306端口，重启防火墙，或者直接关闭防火墙，二选一即可
firewall-cmd --zone=public --add-port=3306/tcp --permanent
systemctl restart firewalld
#关闭防火墙，或者选择打开3306接口访问，二选一即可
systemctl stop firewalld
```

## 8.root账户远程连接

```bash
---选择数据库
use mysql;
--允许任何主机连接
update user set host='%' where user='root';
--刷新权限
flush privileges;
```

## 9.博客来源

```
https://www.jianshu.com/p/b64e6e3bfa24
```

```
systemctl start firewalld  # 开启防火墙
systemctl stop firewalld   # 关闭防火墙
systemctl status firewalld # 查看防火墙开启状态，显示running则是正在运行
firewall-cmd --reload      # 重启防火墙，永久打开端口需要reload一下

# 添加开启端口，--permanent表示永久打开，不加是临时打开重启之后失效
firewall-cmd --permanent --zone=public --add-port=8888/tcp

# 查看防火墙，添加的端口也可以看到
firewall-cmd --list-all
```

