```bash
#Server ID，一般设置成IP地址的最后一位
server_id=52
#开启log bin，名字最好有意义用来区分
log-bin=dev-bin
#需要进行复制的数据库，可以指定数据库,这里我注释掉不用
#binlog-do-db=DB_master
#不需要备份的数据库，可以设置多个数据库，一般不会同步mysql这个库
binlog-ignore-db=mysql
binlog-ignore-db=information_schema
binlog-ignore-db=performance_schema
#为每个session 分配的内存，在事务过程中用来存储二进制日志的缓存
binlog_cache_size=1m
#二进制日志自动删除/过期的天数。默认值为0，表示不自动删除。
expire_logs_days=7
# 跳过主从复制中遇到的所有错误或指定类型的错误，避免slave端复制中断。
# 如：1062错误是指一些主键重复，1032错误是因为主从数据库数据不一致
slave_skip_errors=1062
```

```
server_id=9
#binlog-ignore-db=mydql
#binlog-ignore-db=information_schema
#binlog-ignore-db=performance_schema
#log-bin=dev-slave-bin
binlog_cache_size=1M
binlog_format=mixed
expire_logs_days=7
slave_skip_errors=1062
relay_log=dev-relay-bin
#log_slave_updates=1
read_only=1

master-host=47.105.182.19
master-user=root
master-password=Tao.120908!!!
master-port=3306
```

```
change master to master_host='39.107.142.3',master_user='47.105.182.19',master_password='Mysql.123456',master_port=3306,master_log_file='dev-bin.000002',master_log_pos=613,master_connect_retry=30;
```

```
mysql-community-common-5.7.32-1.el7.x86_64 mysql80-community-release-el7-3.noarch mysql-community-libs-5.7.32-1.el7.x86_64 mysql-community-server-5.7.32-1.el7.x86_64 mysql-community-client-5.7.32-1.el7.x86_64 mysql-community-libs-compat-5.7.32-1.el7.x86_64
```

```
/usr/share/mysql /etc/selinux/targeted/tmp/modules/100/mysql /etc/selinux/targeted/active/modules/100/mysql /var/lib/mysql /var/lib/mysql/mysql
```



```
grant replication slave, replication client on *.* to 'repl'@'47.105.182.19' identified by 'slavePassword!123';
```

```
change master to master_host='39.107.142.3',master_user='repl',master_password='slavePassword!123',master_port=3306,master_log_file='dev-bin.000003',master_log_pos=1231,master_connect_retry=30;
```

