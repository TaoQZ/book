# docker部署SpringBoot项目

创建好一个springboot项目后在本地运行测试没有问题后继续

## pom配置

需要在项目的pom.xml文件中添加

```xml
<!--    将项目打包为jar-->
<packaging>jar</packaging>
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
        <plugin>
            <groupId>com.spotify</groupId>
            <artifactId>docker-maven-plugin</artifactId>
            <version>1.0.0</version>

            <configuration>
                <!--远程Docker的地址-->
                <dockerHost>http://39.107.142.3:2375</dockerHost>
                <!--镜像名称，前缀/项目名-->
                <imageName>${project.artifactId}</imageName>
                <!-- 指定版本 -->
                <imageTags>
                    <imageTag>latest</imageTag>
                </imageTags>

                <!-- 基础镜像FROM -->
                <baseImage>java</baseImage>
                <!-- 著作者信息 -->
                <maintainer>weixinliang</maintainer>
                <!-- 运行后切换到根目录 -->
                <workdir>/ROOT</workdir>

                <!-- 运行命令 -->
                <!--					<cmd>["java","-version"]</cmd>-->
                <!--					<entryPoint>["java","-jar","${project.build.finalName}.jar"]</entryPoint>-->
                <entryPoint>["java" , "-Djava.security.egd-file:/dev/./urandom" , "-jar" ,"${project.build.finalName}.jar"]</entryPoint>


                <!-- DockerFile位置 -->
                <!-- <dockerDirectory>src/main/docker</dockerDirectory> -->
                <!-- 赋值jar包到 docker 指定的目录 -->
                <resources>
                    <resource>
                        <targetPath>/ROOT</targetPath>
                        <!-- 指定需要复制的根目录，即为taiget目录 -->
                        <directory>${project.build.directory}</directory>
                        <!-- 指定需要复制的文件 -->
                        <include>${project.build.finalName}.jar</include>
                    </resource>
                </resources>
            </configuration>
        </plugin>
    </plugins>
</build>
```

2020.5.24以下此版不可用

```xml
<!--    将项目打包为jar-->
<packaging>jar</packaging>

<properties>
    <java.version>1.8</java.version>
</properties>

<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <mainClass>xyz.taoqz.MyApplication</mainClass>
            </configuration>
        </plugin>
        <!--            添加docker 插件-->
        <plugin>
            <groupId>com.spotify</groupId>
            <artifactId>docker-maven-plugin</artifactId>
            <version>1.0.0</version>
            <configuration>
                <!--                    配置docker引擎的地址,格式 http|https://ip:port -->
                <dockerHost>http://35.221.245.195:2375</dockerHost>
                <!--                    如果Docker引擎开启了TLS验证功能，你必须要将客户端证书、秘钥以及CA证书的路径配置在这里-->
                <dockerCertPath>C:\\Users\\Administrator\\.docker\\machine\\cert_79</dockerCertPath>
                <!--                    基准镜像,与Dockerfile中的FROM <baseImage> 指令一致-->
                <baseImage>openjdk:8-alpine</baseImage>
                <!--                    镜像名称,由项目名称与版本号组成-->
                <imageName>${project.build.finalName}</imageName>
                <!--                    镜像tag,默认是项目的版本号和latest-->
                <imageTags>
                    <imageTag>${project.version}</imageTag>
                    <imageTag>latest</imageTag>
                </imageTags>
                <!--                    容器启动时,执行的命令-->
                <entryPoint>["java", "-jar", "/${project.build.finalName}.jar"]</entryPoint>
                <!--                    需要暴露的端口-->
                <exposes>
                    <expose>8080</expose>
                </exposes>
                <resources>
                    <resource>
                        <!--                            打包好的项目文件放置在容器的位置,targetPath路径必须要与entryPoint中的一致-->
                        <targetPath>/</targetPath>
                        <!--                            项目的构建目录-->
                        <directory>${project.build.directory}</directory>
                        <!--                            需要将项目构建目录中哪些内容拷贝至镜像中-->
                        <include>${project.build.finalName}.jar</include>
                    </resource>
                </resources>
            </configuration>
        </plugin>
    </plugins>
</build>
```

## 运行命令

```shell
mvn clean package docker:build
```

可以在IDEA中配置docker指定,先创建指定容器后运行

参考链接:https://www.cnblogs.com/softidea/p/8044031.html