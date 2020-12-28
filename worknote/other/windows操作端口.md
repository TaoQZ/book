windows下查看端口

查看所有运行的端口

```
netstat -ano
```

查看指定端口的占用情况

```
netstat -aon|findstr "8081"
```

结束指定PID的进程

```
taskkill /T /F /PID 9088 
```

```
server {
		listen       8080;
		server_name  localhost;
		ssl_session_timeout  5m;
		#charset koi8-r;
		
		location /resourcenter {
            proxy_pass http://localhost:8989/resourcenter;
            proxy_set_header  Host $host:80;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            client_max_body_size 1000m;
            client_body_buffer_size 10m;
            proxy_connect_timeout 90;
            proxy_send_timeout 90;
            proxy_read_timeout 90;
            proxy_buffer_size 4k;
            proxy_buffers 4 64k;
            proxy_intercept_errors on ;
        }
		
		location /resourceupload {
            proxy_pass http://127.0.0.1:9000;
            proxy_set_header  Host $host:80;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            client_max_body_size 1000m;
            client_body_buffer_size 10m;
            proxy_connect_timeout 90;
            proxy_send_timeout 90;
            proxy_read_timeout 90;
            proxy_buffer_size 4k;
            proxy_buffers 4 64k;
            proxy_intercept_errors on ;
        }
	}
```

