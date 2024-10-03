# 搭建基于公网的samba服务

现在有一台某运营商的服务器，centos8，要在上面搭建一个samba文件共享服务

遇到的问题，本地的windows主机445端口被运营商禁用导致无法连接（同局域网下的samba服务连接时没有问题）

## 解决方案如下

再windows主机上做如下修改

使用管理员打开cmd，设置完成之后 需要重启

```shell
# 将本地445端口转发对应服务器上samba的端口 samba服务的默认端口为445 需要提前将其改为指定端口 如6727
netsh interface portproxy add v4tov4 listenaddress=127.0.0.1 listenport=445 connectaddress=远程服务器IP connectport=6727

# 查看当前windows主机所有连接
netsh interface portproxy show all


# 删除配置
netsh interface portproxy delete v4tov4 listenaddress=127.0.0.1 listenport=445
```

## 访问

在windows资源管理器输入

windows默认时445现在已经将其转发到对应samba服务的主机上的指定端口

这样的弊端就是 其他的映射磁盘将不会再受用，根据情况进行设置

```shell
\\127.0.0.1\shared
```

## 搭建

```shell
# 安装
install samba samba-client samba-common
```

## 配置文件

/etc/samba/smb.conf

示例

```shell
# See smb.conf.example for a more detailed config file or
# read the smb.conf manpage.
# Run 'testparm' to verify the config is correct after
# you modified it.

[global]
        workgroup = SAMBA
        security = user

        passdb backend = tdbsam

        printing = cups
        printcap name = cups
        load printers = yes
        cups options = raw
        
        # samba服务使用的端口 默认为445
        #smb ports = 6727

[homes]
        comment = Home Directories
        valid users = %S, %D%w%S
        browseable = No
        read only = No
        inherit acls = Yes

[printers]
        comment = All Printers
        path = /var/tmp
        printable = Yes
        create mask = 0600
        browseable = No

[print$]
        comment = Printer Drivers
        path = /var/lib/samba/drivers
        write list = @printadmin root
        force group = @printadmin
        create mask = 0664
        directory mask = 0775

[shared]
   # 共享文件夹地址
   path = /srv/samba/share
   writable = yes
   browsable = yes
   guest ok = yes
   # 无论什么用户登录，强制转换为root用户进行操作
   #force user = root
   # 登录时需要验证的用户
   valid users = taoqz
   create mask = 0755
   directory mask = 0775
```

## 创建用户

输入命令后后让你输入密码和确认密码

```shell
sudo smbpasswd -a taoqz
```

## 遇到文件夹没有权限时

```shell
sudo chown -R taoqz:taoqz /srv/samba/share
sudo chmod -R 0777 /srv/samba/share
```

