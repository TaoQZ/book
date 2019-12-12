# Feign

​	简化远程调用代码,支持SpringMVC注解,不需要拼接url地址,同时整合了负载均衡Ribbon以及服务熔断(Hystrix)

## 入门使用

服务调用者

### 依赖

```xml

  <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.2.1.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
  </parent>
    
    <dependencies>
    <!--  feign依赖   -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
    </dependencies>  
    
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

### 注解

```java
// 启动类上添加
@EnableFeignClients // 开启Feign功能
```

### 配置

​	虽然Feign集成了Hystrix熔断,但默认是关闭的

```yaml
feign:
  hystrix:
    enabled: true # 开启Feign的熔断功能
```

​	同样支持对Ribbon负载均衡的配置

```yaml
#服务名 如果不写服务名是全局配置
ribbon:
  ConnectTimeout: 250 # 连接超时时间(ms)
  ReadTimeout: 1000 # 通信超时时间(ms)
  OkToRetryOnAllOperations: true # 是否对所有操作重试
  MaxAutoRetriesNextServer: 1 # 同一服务不同实例的重试次数
  MaxAutoRetries: 1 # 同一实例的重试次数
```

### 逻辑代码

```java
// 创建接口 添加访问的服务名称以及熔断时进行处理的class类(接口的实现类)
@FeignClient(value = "user-service-tao",fallback = UserFeignClientFallback.class)
public interface UserFeignClient {

    @GetMapping("/user/{id}")
    User queryUserById(@PathVariable("id") Long id);

}
```

```java
// 实现Feign的接口,重写回调函数
@Component
public class UserFeignClientFallback implements UserFeignClient{
    @Override
    public User queryUserById(Long id) {
        User user = new User();
        user.setId(id);
        user.setName("用户查询出现异常！");
        return user;
    }
}
```

```java
 // 注入后接口并调用 
 @Autowired
 private UserFeignClient userFeignClient;
 
 public User queryUserById(Long id){
     User user = userFeignClient.queryUserById(id);
     return user;
 }   
```

### 请求压缩

​	Spring Cloud Feign 支持对请求和响应进行GZIP压缩，以减少通信过程中的性能损耗。通过下面的参数即可开启请求与响应的压缩功能：

```yaml
feign:
  compression:
    request:
      enabled: true # 开启请求压缩
    response:
      enabled: true # 开启响应压缩
```

同时，我们也可以对请求的数据类型，以及触发压缩的大小下限进行设置：

```yaml
feign:
  compression:
    request:
      enabled: true # 开启请求压缩
      mime-types: text/html,application/xml,application/json # 设置压缩的数据类型
      min-request-size: 2048 # 设置触发压缩的大小下限
```

注：上面的数据类型、压缩大小下限均为默认值。