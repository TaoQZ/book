## 删除镜像

当有多个镜像名称相同时进行删除会出现以下错误

```shell
Error response from daemon: conflict: unable to delete c50e9004f4ce (must be forced) - image is referenced in multi
ple repositories
```

解决方案,使用其版本tag进行删除

```shell
docker rmi 镜像名称:1.0
```



# 解决docker启动容器时 报 iptables 规则相关问题

```sh
sudo systemctl stop docker
```

```sh
sudo iptables -t nat -F
```

```sh
sudo iptables -t filter -F
```

```sh
sudo iptables -t nat -X
```

```sh
sudo iptables -t filter -X
```

```sh
sudo systemctl start docker
```




# 修改docker默认使用的网络

```sh
systemctl stop docker
```

```sh
vim /etc/docker/daemon.json

{
  "bip": "172.20.0.1/16"
}
```

```sh
ip link set dev docker0 down
```

```sh
ip link delete docker0
```

```sh
systemctl start docker
```

```sh
docker network inspect bridge
```



# 如果遇到有 容器开放端口 但是外部还是访问不到的情况

SELinux 

有时 SELinux 会拦截非标准端口（比如 10080）。

查看 Nginx 是否有权限监听：

```sh
getsebool -a | grep httpd
```

临时关闭 SELinux 测试：

```sh
setenforce 0
```



iptables   

host 模式下容器和宿主机共享 iptables，如果有自定义规则，可能拦截了端口。

检查规则：

```sh
iptables -L -n
```

可以先清空规则测试：

```sh
iptables -F
```





```nginx
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}



http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;
    client_max_body_size 100M;


    gzip  on;
    gzip_min_length  10k;
    gzip_buffers     4 16k;
    gzip_http_version 1.1;
    gzip_comp_level 9;
    gzip_types
     text/plain
     application/x-javascript
     text/css
     application/xml
     text/javascript
     application/x-httpd-php
     application/javascript
     application/json
     application/x-font-ttf
     application/x-font-opentype
     application/vnd.ms-fontobject
     application/font-woff
     application/font-woff2
     application/wasm
     font/ttf
     font/otf
     font/woff
     font/woff2;
    gzip_disable "MSIE [1-6]\.";
    gzip_vary on;

    server {
        listen 80; # 监听指定 IP 地址和端口号
        server_name localhost; # 服务器名（如果需要）
        charset utf-8; 
	
        # 光伏大屏	
        location /test-api {
             rewrite ^/test-api/(.*)$ /$1 break;
             proxy_pass http://192.168.1.4:18080;
        }
       
 
       # 确保 /app/ 能正确映射
       location /app/ {
            alias /home/nginx/html/app/;
            autoindex on;   # 可选，允许目录浏览
       }  

       location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
       }

       error_page 404 /50x.html;
           location = /50x.html {
           root   html;
       }

       
        
    }

#    server {
#      listen 443 ssl; # 监听443端口，启用SSL和HTTP/2
#      http2 on;
#      server_name localhost; # 设置服务器的域名
#
#      # SSL证书和密钥位置
#      ssl_certificate /etc/nginx/conf.d/cert/*.pem; # SSL证书的位置
#      ssl_certificate_key /etc/nginx/conf.d/cert/*.key; # SSL证书密钥的位置
#
#      # SSL安全设置
#      ssl_protocols TLSv1.2 TLSv1.3; # 指定使用TLS 1.2和TLS 1.3协议
#      ssl_prefer_server_ciphers on; # 优先使用服务器指定的密码套件
#      ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
#       
#      location / {
#         root   /usr/share/nginx/html;
#         index  index.html index.htm;
#         proxy_pass http://localhost:80/;
#      }
#    }



}

```



```sh
docker run  --name nginx --network host --restart=always -v /home/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /home/nginx/logs:/var/log/nginx -v /home/nginx/html:/usr/share/nginx/html -v /etc/localtime:/etc/localtime  -itd nginx:latest
```

