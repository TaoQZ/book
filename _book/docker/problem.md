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

