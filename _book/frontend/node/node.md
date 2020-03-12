# Node.js

## 什么是Node.js

​	Node.js是一个服务器端的JavaScript运行环境,可以让前端使用Node.js提供HTML,CSS,JS等资源访问,提供npm插件用于管理所有js资源,和java中的maven类似

## 安装与配置

最新版本: https://nodejs.org/zh-cn/download/

历史版本: https://nodejs.org/zh-cn/download/releases/

windows下载msi文件后傻瓜式安装

查看node版本:

```
node -v
node -version 10版本方式
```

切换源工具

安装完node后会自带一个npm,但默认的源在国外,访问会比较慢,切换成国内源

安装nrm

```
npm install -g nrm
```

查看当前源

```
nrm ls
```

切换源

```
nrm use taobao
```

安装(下载)包,版本是可选项,下载后在node_modules文件夹里

```
npm install <packagename>[@<version>]
```

全局安装

```
npm install -g <package>
```

全局卸载

```
npm uninstall -g <package>
```

