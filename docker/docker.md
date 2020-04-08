# Docker

docker是什么?为什么使用?



## 安装

```properties
# 卸载旧版本
apt-get remove docker docker-engine docker.io containerd runc
# 使用apt安装
# 更新数据源
apt-get update
# 安装所需依赖
apt-get -y install apt-transport-https ca-certificates curl software-properties-common
# 安装 GPG 证书
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
# 新增数据源
add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
# 更新并安装 Docker CE
apt-get update && apt-get install -y docker-ce
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