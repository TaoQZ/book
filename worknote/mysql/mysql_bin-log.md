```
mysql开启bin-log,在my.ini中配置

# Binary Logging.
log-bin=D:\MySQL\mybinlog\mysql_bin
server-id=120908
binlog-format=Row 
```

```
mysqlbinlog   --start-position=391772 --stop-position=392035  D:\MySQL\mybinlog\mysql_bin.000001  > d:\test.sql
```

```
 source d:\test.sql
```

```
mysqlbinlog   --start-datetime="2021-05-11 12:28:00" --stop-datetime="2021-05-11 12:28:10"  D:\MySQL\mybinlog\mysql_bin.000001  > d:\test2.sql
```

