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
                <dockerHost>http://39.107.xxx.x:2375</dockerHost>
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

## 运行命令

```shell
mvn clean package docker:build
```

可以在IDEA中配置docker指定,先创建指定容器后运行

参考链接:https://www.cnblogs.com/softidea/p/8044031.html