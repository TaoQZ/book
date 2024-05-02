# minio搭建集群

minio最少要求4台服务器

在一台服务器上操作,其他服务器也会有影响

## 下载

```
https://min.io/download#/linux
```

## 搭建

以下命令需要在所有集群服务器上运行

```shell
# 创建minio文件(存储minio软件及数据),将下载的minio保存至/usr/local/minio下
mkdir -p /usr/local/minio/miniodata
# 使之可运行
chmod +x minio
# 账号
export MINIO_ACCESS_KEY=minio
# 密码
export MINIO_SECRET_KEY=minio123
# 运行启动 /usr/local/minio/miniodata 则为真正存储数据的文件夹
# 集群通信认证也是根据上面的账号密码
./minio server http://192.168.84.103/usr/local/minio/miniodata http://192.168.84.105/usr/local/minio/miniodata http://192.168.84.107/usr/local/minio/miniodata http://192.168.84.108/usr/local/minio/miniodata
```

## nginx负载均衡

集群搭载完后可在任意一台服务器上搭建nginx进行负载均衡

nginx主要配置

```shell
upstream myserver {
    # ip_hash;  # ip_hash 方式
    # fair;   # fair 方式
    server 192.168.84.103:9000;  # 负载均衡目的服务地址
    server 192.168.84.105:9000;  # weight=2;  weight 方式，不写默认为 1 
    server 192.168.84.107:9000;
    server 192.168.84.108:9000;
}

server {
    listen       8088;
    location / {
        # 此处的myserver对应上面 upstream后的名称,名称中最好不要加_ 下划线
        proxy_pass http://myserver;
        proxy_connect_timeout 10;
        # 显示具体负载的机器的ip,X-Route-Ip随便命名
        add_header X-Route-Ip $upstream_addr;
        add_header X-Route-Status $upstream_status;
    }
}
```



## 集群服务器下线影响

以四台为例

三台: 可进行正常操作
两台: 可正常访问,不可对文件进行操作(上传,删除等)
一台: 访问出错

```
We encountered an internal error, please try again.: cause(Read failed. Insufficient number of disks online)
```