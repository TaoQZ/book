# centos完全卸载mysql

## 1.查看mysql安装了哪些东西

```bash
rpm -qa |grep -i mysql
```

![image-20201107100907655](centos卸载mysql.assets/image-20201107100907655.png)

## 2.卸载

```
yum remove mysql57.....
```

## 3.再次查看是否卸载完全

```bash
rpm -qa |grep -i mysql
```

## 4.查找mysql相关目录

```bash
find / -name mysql
```

## 5.删除相关目录

```bash
rm -rf 
```

## 6.删除mysql的配置文件

有可能 my.cnf 文件还有一个后缀,可以cat一下查看是否时mysql的配置文件然后删除

```bash
rm -rf /etc/my.cnf
```

## 7.删除mysql日志文件

```bash
rm -rf /var/log/mysqld.log
```

## 8.博客来源

```
https://www.jianshu.com/p/ef58fb333cd6
```

