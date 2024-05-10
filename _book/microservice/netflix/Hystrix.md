# Hystrix

​	熔断,在分布式系统中,高并发的环境下服务可能因为压力会出现宕机,而其他的服务可能会依赖该服务,并且导致级联的失败,但是在生产环境中应该避免让用户看到错误的情况,所以可以使用熔断来解决相关问题

​	类似生活中的保险丝,当出现漏电等情况,会将保险丝熔断,避免出现火灾

## 使用

​	在服务调用方进行操作

### 	环境

```xml
 <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.2.1.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
  </parent>

<!-- SpringCloud的依赖 -->
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
    <!-- Spring的仓库地址 -->
    <repositories>
        <repository>
            <id>spring-milestones</id>
            <name>Spring Milestones</name>
            <url>https://repo.spring.io/milestone</url>
            <snapshots>
                <enabled>false</enabled>
            </snapshots>
        </repository>
    </repositories>

```

### 	依赖

```xml
 <!--    Hystrix熔断    -->
 <dependency>
	 <groupId>org.springframework.cloud</groupId>
	 <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
 </dependency>
```

### 	注解

```java
// 在启动类上添加
@EnableHystrix // 开启Hystrix熔断
```

### 	逻辑代码

```java
// 在需要熔断的方法上添加注解并指定熔断的回调函数
@HystrixCommand(fallbackMethod = "queryUserByIdFallback")
public User queryUserById(Long id) {
	String url = "http://user-service-tao/user/" + id;
	User user = restTemplate.getForObject(url, User.class);
	return user;
}
// 熔断后的回调函数 参数及返回值一致
 public User queryUserByIdFallback(Long id){
        User user = new User();
        user.setId(id);
        user.setName("用户信息查询出现异常！");
        return user;
    }
```

### 	配置

​	其默认的触发熔断的时间为1s,所以当结合重试使用时,需要将熔断的时间设置的比重试的时间长一些,不然重试就没有了其意义

```yaml
hystrix:
  command:
  	default:
        execution:
          isolation:
            thread:
              timeoutInMilliseconds: 6000 # 设置hystrix的超时时间为6000ms
```

