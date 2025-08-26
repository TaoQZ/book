查看容器的日志

```shell
docker logs 容器Id
```

查看容器详情信息

```shell
docker inspect 容器Id
```

解决docker启动容器时 报 iptables 规则相关问题

```shell
sudo systemctl stop docker
sudo iptables -t nat -F
sudo iptables -t filter -F
sudo iptables -t nat -X
sudo iptables -t filter -X
sudo systemctl start docker
```

修改docker默认使用的网络

```shell
systemctl stop docker

vim /etc/docker/daemon.json

{
  "bip": "172.20.0.1/16"
}

ip link set dev docker0 down
ip link delete docker0

systemctl start docker

docker network inspect bridge
```

一次性启动所有状态为停止的容器

```shell
docker ps -aq -f status=exited | xargs docker start
```

启动所有指定前缀的容器

```shell
docker ps -a --filter "name=^/security-" --format "{{.Names}}" | xargs -r docker start
```

搭建环境用到的命令

nginx

需要先创建文件 /home/nginx/conf/nginx.conf

```shell
docker run  --name nginx --network host --restart=always -v /home/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /home/nginx/logs:/var/log/nginx -v /home/nginx/html:/usr/share/nginx/html -v /etc/localtime:/etc/localtime  -itd nginx:latest
```

代理示例

```shell
location /test-stage-api {
     rewrite ^/test-stage-api/(.*)$ /$1 break;
     proxy_pass http://192.168.3.1:8084;
}
```

redis

```shell
docker run -itd --network host --name redis -p 6379:6379 -v /home/redis/conf/redis.conf:/etc/redis/redis.conf -v /home/redis/data:/data redis:latest redis-server /etc/redis/redis.conf --appendonly yes
```

minio

```shell
docker run -d -p 9000:9000 -p 9090:9090 --name minio --network host -v /home/minio/data:/data -e "MINIO_ROOT_USER=minio" -e "MINIO_ROOT_PASSWORD=minio123" minio/minio:RELEASE.2023-05-18T00-05-36Z.fips server /data --console-address ":9090"
```

mysql

```shell
docker run -itd -p 3306:3306 --name mysql  --privileged=true --restart=unless-stopped -v /home/mysql/conf/my.cnf:/etc/mysql/my.cnf -v /home/mysql/logs:/var/log/mysql -v /home/mysql/data:/var/lib/mysql -v /home/mysqlnew/mysql-files:/var/lib/mysql-files  -e MYSQL_ROOT_PASSWORD=123456 mysql:8.0.27
```

nacos

```shell
docker run --name=nacos-quick2 --hostname=e22c6434ea66 --env=MODE=standalone --network=host --workdir=/home/nacos --runtime=runc --detach=true nacos/nacos-server:2.0.2
```

oracle

```shell
docker run -itd \
-p 1521:1521 \
--name oracle \
--mount source=oracle_vol,target=/home/oracle/app/oracle/oradata \
registry.cn-hangzhou.aliyuncs.com/helowin/oracle_11g
```

