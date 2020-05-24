下载

```shell
curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
```

加权限

```shell
sudo chmod +x /usr/local/bin/docker-compose
```

启动

会自动找文件名称为docker-compose.yml的文件

```shell
docker-compose up -d
```

停止

```shell
docker-compose down
```

部署MySQL

```yaml
version: '3.1'
services:
  db:
    # 目前 latest 版本为 MySQL8.x
    image: mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: 123456
    command:
      --default-authentication-plugin=mysql_native_password
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_general_ci
      --explicit_defaults_for_timestamp=true
      --lower_case_table_names=1
    ports:
      - 3306:3306
    volumes:
      - ./data:/var/lib/mysql

  # MySQL 的 Web 客户端
  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080
```

