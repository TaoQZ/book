```
server {
    # 服务器端口使用443，开启ssl, 这里ssl就是上面安装的ssl模块
    listen       443 ssl;
    # 域名，多个以空格分开
    server_name  www.taoqz.xyz;

    # ssl证书地址
    ssl_certificate     /etc/nginx/https/3870913_www.taoqz.xyz.pem;  # pem文件的路径
    ssl_certificate_key  /etc/nginx/https/3870913_www.taoqz.xyz.key; # key文件的路径

    # ssl验证相关配置
    ssl_session_timeout  5m;    #缓存有效期
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;    #加密算法
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;    #安全链接可选的加密协议
    ssl_prefer_server_ciphers on;   #使用服务器端的首选算法
 location / {
        root   html;
        index  index.html index.htm;
    }
}

server {
    listen       80;
    server_name  www.taoqz.xyz;
    return 301 https://$server_name$request_uri;
}
```