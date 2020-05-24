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

## 安装docker-compose

```shell
# 运行以下命令以下载Docker Compose的当前稳定版本：
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 将可执行权限应用于二进制文件：
sudo chmod +x /usr/local/bin/docker-compose

# 如果命令docker-compose在安装后失败，请检查路径。您也可以创建指向/usr/bin或路径中任何其他目录的符号链接
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# 测试安装。
$ docker-compose --version
docker-compose version 1.25.5, build 1110ad01
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

- 创建容器并运行

```
docker run -itd --name redis -p 6379:6379 redis
```

```
i:交互式操作 t:终端 d:后台运行 p:将容器内部使用的网络端口映射到我们使用的主机上(前面是主机开放的端口,后面是docker容器开放的端口) 
--name 自定义的容器名称 最后的名称是镜像名称
```

- 使用run命令时直接进入容器

不能加d参数,但这种方式退出容器后也会停止容器

```
docker run -it 镜像  /bin/bash
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

- 停止正在运行的所有容器

```
docker stop $(docker ps -a -q)
```

- 运行一个停止的容器

```
docker start 容器name
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





