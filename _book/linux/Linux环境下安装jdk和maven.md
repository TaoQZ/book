环境:

Ubuntu18.04

jdk1.8

maven3.6.0

将jdk和maven的linux版本的压缩包上传或下载到服务器中

首先进入root:

```shell
sudo -i
```

解压:

```shell
tar zxvf ****.tar.gz
```

如果需要移动到另一个文件夹中:

```shell
mv 需要移动的文件文件名 要移动到的文件夹地址
```

解压后删除原压缩包:

```shell
rm -rf 文件名	
```

配置环境变量:

```shell
vi /etc/profile	
```

输入i进入编辑模式即insert添加以下代码

```shell
export JAVA_HOME=/usr/local/java/jdk1.8.0_141 为具体的安装位置
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
export M2_HOME=/usr/local/maven/apache-maven-3.6.0 为具体的安装位置
export PATH=${M2_HOME}/bin:$PATH
```

编辑完成后

```
按 esc 退出编辑模式再输入 :wq 保存后退出
```

使修改后的配置文件生效

```shell
source /etc/profile
```

检验是否安装成功

```
java -version 查看java版本
mvn -v 查看maven版本
```

可能出现的问题:

vi ll 等命令不能使用可能是环境变量编辑有问题,输入以下命令解决

```shell
export PATH=/usr/bin:/usr/sbin:/bin:/sbin:/usr/X11R6/bin
```

