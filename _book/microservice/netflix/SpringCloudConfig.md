# SpringCloud Config

## 介绍

​	在分布式环境中,由于服务数量巨多,为了方便将配置文件统一管理,实时更新,所以需要分布式配置中心组件。在SpringCloud中提供了SpringCloud Config组件作为远程配置中心,该组件分为两个角色,一个是server端,一个是client端。Server端默认使用Git作为配置文件的存储中心,Client在启动时会请求Server获取配置文件中的内容。

## 使用

默认都使用springboot项目,springcloud本身也是基于springboot搭建的

## 服务端

### 依赖

```xml
 <dependencies>
<!--        该应用为web项目-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
<!--    该应用为config的server端-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-config-server</artifactId>
        </dependency>
    </dependencies>

<!--    用于管理依赖的版本,这里用于指定springcloud的版本-->
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>Hoxton.RELEASE</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
```

启动类上添加注解

```java
@EnableConfigServer
```

### 配置文件

application.yml

```yml
server:
  port: 8001
spring:
  application:
    name: spring-cloud-config-server
#    使用指定的环境(根据配置文件的名称后缀指定)
  profiles:
    active: test
  cloud:
    config:
      server:
        git:
          uri:      # 配置git仓库的地址
          default-label: master #配置文件分支
          search-paths: config  # git仓库地址下的相对地址，可以配置多个，用,分割。
          username:   # git仓库的账号
          password:   # git仓库的密码
```

### Git文件结构

项目(也就是配置文件中uri中的后缀)/文件夹(配置文件中search-paths的值)/配置文件 

配置文件的命名规则: {application}-dev | test | prod.yml

## 客户端

### 依赖

```xml
 <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- spring cloud config 客户端包 -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-config</artifactId>
        </dependency>
<!--        可以监控服务,可以查看应用配置的详细信息-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
    </dependencies>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>Hoxton.RELEASE</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
```

不需要在启动类上添加任何注解

### 配置文件

application.yml

```yml
spring:
  application:
    name: config-demo-client

# 开启或关闭接口优雅的关闭springboot项目
management:
  endpoint:
    shutdown:
#      关闭
      enabled: false
#      包含所有端点(打开所有的监控点)
  endpoints:
    web:
      exposure:
        include: "*"
```

如果shutdown的配置为true,可以通过该接口(Post):http://localhost:8080/actuator/shutdown,关闭服务。关闭时得到的响应

```json
{
  "message": "Shutting down, bye..."
}
```

bootstrap.properties

```properties
# 配置文件的名称
spring.cloud.config.name=config-demo-client-test
# 配置文件的环境（例如：dev,test,prod）也就是配置文件名称的后缀
spring.cloud.config.profile=test
# spring cloud config的server端地址
spring.cloud.config.uri=http://localhost:8001/
# 配置文件所在git仓库中的分支
spring.cloud.config.label=master
```

关于spring-cloud的相关属性必须配置在bootstrap.properties中,config部分内容才能被正确加载。因为config的相关配置会先于application.properties,而bootstrap.properties的加载也是先于application.properties。

### controller

创建一个controller用于读取配置文件中的属性进行测试

```java
@RestController
@RequestMapping("/user")
public class WebController {
    @Value("${data.user.username}")
    private String username;

    @GetMapping
    public String fun(){
        return username;
    }
}
```

访问接口: http://localhost:8080/user 成功拿到了数据,但是更新git中配置文件内容后再次访问数据并未更新,此时便需要用到了监控包actuator

### 修改后的controller

```java
@RestController
@RefreshScope // 使用该注解的类，会在接到SpringCloud配置中心配置刷新的时候，自动将新的配置更新到该类对应的字段中。
@RequestMapping("/user")
public class WebController {

    @Value("${data.user.username}")
    private String username;

    @GetMapping
    public String getUsername(){
        return username;
    }

}
```

再次访问http://localhost:8080/user ,数据还是没有发生改变

需要使用post的方式访问该路径进行刷新:http://localhost:8080/actuator/refresh

访问配置文件中的所有内容(Get):http://localhost:8001/config-demo-client/dev

其中config-demo-client则是client端服务的名称,test则是对应的配置环境

