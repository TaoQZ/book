# Docker安装及使用

## 安装

```properties
# 更新数据源
apt-get update
# 卸载旧版本
apt-get remove docker docker-engine docker.io containerd runc
# 使用apt安装
apt install docker.io
# 安装所需依赖
# apt-get -y install apt-transport-https ca-certificates curl software-properties-common
# 安装 GPG 证书
# curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
# 新增数据源
# add-apt-repository "deb [arch=amd64] # http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
# 更新并安装 Docker CE
# apt-get update && apt-get install -y docker-ce
```

验证安装是否成功

```properties
docker version
```

使用阿里云镜像

```properties
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://mkax6sr2.mirror.aliyuncs.com"]
}
EOF

# 重启 Docker
systemctl daemon-reload
systemctl restart docker

# 验证配置是否成功
docker info
```



## 常用命令

- 查看 Docker 版本

```
docker version
```

- 从 Docker 文件构建 Docker 映像

```
docker build -t image-name docker-file-location
```

- 运行 Docker 映像

```
docker run -d image-name
```

- 查看可用的 Docker 映像

```
docker images
```

- 查看最近的运行容器

```
docker ps -l
```

- 查看所有正在运行的容器

```
docker ps -a
```

- 停止运行容器

```
docker stop container_id
```

- 删除一个镜像

```
docker rmi image-name
```

- 删除所有镜像

```
docker rmi $(docker images -q)
```

- 强制删除所有镜像

```
docker rmi -f $(docker images -q)
```

- 删除所有虚悬镜像

```
docker rmi $(docker images -q -f dangling=true)
```

- 删除所有容器

```
docker rm $(docker ps -a -q)
```

- 进入 Docker 容器

```
docker exec -it container-id /bin/bash
```

- 查看所有数据卷

```
docker volume ls
```

- 删除指定数据卷

```
docker volume rm [volume_name]
```

- 删除所有未关联的数据卷

```
docker volume rm $(docker volume ls -qf dangling=true)
```

- 从主机复制文件到容器

```
docker cp host_path containerID:container_path
```

- 从容器复制文件到主机

```
docker cp containerID:container_path host_path
```





