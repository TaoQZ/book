# Eureka

​	服务发现与注册中心

​	由Netflix开发的服务发现框架,本身是一个基于REST的服务

​	主要组件	

​		Eureka Serve:服务端,提供服务注册和发现的功能

​		Eureka Client:客户端,与Eureka Serve的交互,客户端启动后会自动注册到其启动时配置的地址的服务端

## 	作用

​	对服务进行统一管理

​		提供服务的注册于发现,将所有的服务进行统一管理,不需要开发人员手动维护,需要使用哪个服务,直接在服务中心中获取就行

​		实现对服务的状态管理,如果某个服务下线,会有通知,专业术语是心跳,服务提供者会定期通过http方式向Eureka刷新自身的状态,同时Eureka会将所有提供者的地址发送给消费者,并定期更新		

​		结合其他技术(Ribbon)实现了负载均衡		

##         为什么要使用

​	微服务的基础还是服务,将一个单体应用拆分为微服务架构的应用,其中服务之间需要相互依赖,相互调用,但是服务被部署在不同的服务器上,如果服务一旦过多,那么会出现访问的地址(接口)难以进行管理,如果有集群,还需要自行实现负载均衡,并且其中有某个服务停掉也不会接到通知,为了解决等等之类的问题,便诞生了服务发现与注册中心

## 	入门案例

​		分为服务端和客户端,引入Eureka都需要三步,添加依赖,配置,注解

​		首先都需要引入SpringCloud的依赖

​		该案例使用的SpringCloud的Hoxton.RELEASE版本,需要结合springboot2.2.x使用

```xml
 <!-- SpringCloud的依赖 做到版本管理的作用 -->
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

### 服务端	

#### 依赖

```xml
 <!-- Eureka服务端 -->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
</dependency>
```

#### 配置	

```yaml
server:
  port: 8080 # 端口
spring:
  application:
    name: eureka-server # 应用名称，会在Eureka中显示
eureka:
  client:
    register-with-eureka: false # 是否注册自己的信息到EurekaServer，默认是true
    fetch-registry: false # 是否拉取其它服务的信息，默认是true
    service-url: # EurekaServer的地址，现在是自己的地址，如果是集群，需要加上其它Server的地址。
      defaultZone: http://127.0.0.1:${server.port}/eureka
```

#### 注解

​	在启动类上添加

```java
@EnableEurekaServer // 声明这个应用是一个EurekaServer
```

访问:http://127.0.0.1:8080

### 客户端

#### 依赖

```xml
<!-- Eureka客户端 -->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>		
```

#### 配置

```yaml
server:
  port: 8081
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/mydb?useUnicode=true&characterEncoding=utf8
    username: root
    password: 123
    driver-class-name: com.mysql.jdbc.Driver
  application:
    name: user-service # 应用名称
eureka:
  client:
    service-url: # EurekaServer地址
      defaultZone: http://127.0.0.1:8080/eureka
  instance:
    prefer-ip-address: true # 当调用getHostname获取实例的hostname时，返回ip而不是host名称(也就是根据主机名还是ip访问)
    ip-address: 127.0.0.1 # 指定自己的ip信息，不指定的话会自己寻找
```

#### 注解

```java
// 两者选其一
@EnableEurekaClient // 开启EurekaClient功能
@EnableDiscoveryClient // 开启Eureka客户端
```

客户端又分为生产者和消费者,生产者也就是服务提供者,需要将自身注册到服务中心即可,而消费者需要到服务中心调用对应的服务,服务中心存储的相当于服务名称=多个服务地址的键值对

#### 使用DiscoveryClient类

```java
 // 必须导入org.springframework.cloud.client.discovery.DiscoveryClient
 @Autowired
 private DiscoveryClient discoveryClient;

 public void demo(){
        // 根据服务名称,拿到所有已注册的服务实例,因为可能会有集群所以是个集合
        List<ServiceInstance> instances = discoveryClient.getInstances("user-service");
        // 拿到其中一个实例
        ServiceInstance serviceInstance = instances.get(0);
        // host主机地址
        String host = serviceInstance.getHost();
        // port端口号
        int port = serviceInstance.getPort();
        String url = "http://"+host+":"+port+"controller地址及参数";
    }
```

结合RestTemplate使用

```java
@Configuration
public class RestTemplateConfig {
    @Bean
    public RestTemplate restTemplate(){
        RestTemplate restTemplate = new RestTemplate();
        // 解决乱码
        restTemplate.getMessageConverters().add(1,new StringHttpMessageConverter(Charset.forName("UTF-8")));
        return restTemplate;
    }
}
```

```yaml
#修改Eureka服务实例的显示
eureka:
  instance:
    instance-id: ${spring.application.name}:${server.port}
```

### 负载均衡

​	首先负载均衡是在集群的基础上,集群就是将相同功能的代码部署到不同的服务器,而负载均衡则是将流量平均分发到集群的不同服务上,同时做集群的目的也就是为了负载均衡,其中负载均衡又有很多策略,也就是实现负载均衡的算法

​	Eureka中集成了Ribbon负载均衡器,使用时只需要简单的配置即可

​	使用

​	在RestTemplate的配置方法上添加`@LoadBalanced`注解：

​	添加该注解后,才可以使用服务名的方式访问

```java
@Configuration
public class RestTemplateConfig {
    @Bean
    // 开启负载均衡
    @LoadBalanced
    public RestTemplate restTemplate(){
        RestTemplate restTemplate = new RestTemplate();
        // 解决乱码
        restTemplate.getMessageConverters().add(1,new StringHttpMessageConverter(Charset.forName("UTF-8")));
        return restTemplate;
    }
}
```

​	修改调用方式,从host+port改为直接调用服务名称的方式

```java
http://服务名称/controller方法的映射地址
String url = "http://user-service/user/"+id;
```

​	默认使用的是轮询机制,注入RibbonLoadBalanceClient类进行测试

```java
@RunWith(SpringRunner.class)
@SpringBootTest(classes = 启动类.class)
public class LoadBalanceTest {

    @Autowired
    RibbonLoadBalancerClient client;

    @Test
    public void test(){
        for (int i = 0; i < 100; i++) {
            ServiceInstance instance = this.client.choose("集群的服务名");
            System.out.println(instance.getHost() + ":" + instance.getPort());
        }
    }
}
```

​	修改负载均衡的策略

​	查看IRule接口的实现类,可以找到其他实现负载均衡的策略

​	在客户端添加配置

```yaml
# 根
user-service: # 服务名
  ribbon:
    NFLoadBalancerRuleClassName: com.netflix.loadbalancer.RandomRule #策略
```



### 高可用Eureka

 将多个EurekaServer相互注册为服务

启动多个EureakServe服务,进行相互注册,只需要将注册地址的ip互换

```yaml
server:
  port: 10086 # 端口
spring:
  application:
    name: eureka-server # 应用名称，会在Eureka中显示
eureka:
  client:
    service-url: # 配置其他Eureka服务的地址，而不是自己，比如10087
      defaultZone: http://127.0.0.1:10087/eureka
```

客户端注册到Eureka服务集群

```yaml
eureka:
  client:
    service-url: # EurekaServer地址,多个地址以','隔开 EurekaServer集群只需注册在一台上即可共享
      defaultZone: http://127.0.0.1:10086/eureka
```

#### 服务续约

```yaml
eureka:
  instance:
    lease-expiration-duration-in-seconds: 90 #超过90秒默认该服务宕机
    lease-renewal-interval-in-seconds: 30 #每30秒发送一次心跳
```

当服务消费者启动时，会检测`eureka.client.fetch-registry=true`参数的值，如果为true，则会从Eureka Server服务的列表只读备份，然后缓存在本地。并且`每隔30秒`会重新获取并更新数据。我们可以通过下面的参数来修改：

```yaml
eureka:
  client:
    registry-fetch-interval-seconds: 5
```



#### 失效剔除和自我保护

> 失效剔除

有些时候，我们的服务提供方并不一定会正常下线，可能因为内存溢出、网络故障等原因导致服务无法正常工作。Eureka Server需要将这样的服务剔除出服务列表。因此它会开启一个定时任务，每隔60秒对所有失效的服务（超过90秒未响应）进行剔除。

可以通过`eureka.server.eviction-interval-timer-in-ms`参数对其进行修改，单位是毫秒，生成环境不要修改。

这个会对我们开发带来极大的不便，你对服务重启，隔了60秒Eureka才反应过来。开发阶段可以适当调整，比如10S

> 自我保护

我们关停一个服务，就会在Eureka面板看到一条警告：

![1525618396076](assets/1525618396076.png)

这是触发了Eureka的自我保护机制。当一个服务未按时进行心跳续约时，Eureka会统计最近15分钟心跳失败的服务实例的比例是否超过了85%。在生产环境下，因为网络延迟等原因，心跳失败实例的比例很有可能超标，但是此时就把服务剔除列表并不妥当，因为服务可能没有宕机。Eureka就会把当前实例的注册信息保护起来，不予剔除。生产环境下这很有效，保证了大多数服务依然可用。

但是这给我们的开发带来了麻烦， 因此开发阶段我们都会关闭自我保护模式：

在eureka的yml文件中配置

```yaml
eureka:
  server:
    enable-self-preservation: false # 关闭自我保护模式（缺省为打开）
    eviction-interval-timer-in-ms: 1000 # 扫描失效服务的间隔时间（缺省为60*1000ms）
```

#### 重试机制

​	CAP原则：CAP原则又称CAP定理，指的是在一个分布式系统中，Consistency（一致性）、 Availability（可用性）、Partition tolerance（分区容错性），三者不可兼得

Eureka的服务治理强调了CAP原则中的AP，即可用性和可靠性。它与Zookeeper这一类强调CP（一致性，可靠性）的服务治理框架最大的区别在于：Eureka为了实现更高的服务可用性，牺牲了一定的一致性，极端情况下它宁愿接收故障实例也不愿丢掉健康实例，正如我们上面所说的自我保护机制。

但是，此时如果我们调用了这些不正常的服务，调用就会失败，从而导致其它服务不能正常工作！这显然不是我们愿意看到的。

```yaml
spring:
  cloud:
    loadbalancer:
      retry:
        enabled: true # 开启Spring Cloud的重试功能
user-service:
  ribbon:
    ConnectTimeout: 250 # Ribbon的连接超时时间
    ReadTimeout: 1000 # Ribbon的数据读取超时时间
    OkToRetryOnAllOperations: true # 是否对所有操作都进行重试
    MaxAutoRetriesNextServer: 1 # 切换实例的重试次数
    MaxAutoRetries: 1 # 对当前实例的重试次数
```



根据如上配置，当访问到某个服务超时后，它会再次尝试访问下一个服务实例，如果不行就再换一个实例，如果不行，则返回失败。切换次数取决于`MaxAutoRetriesNextServer`参数的值

引入spring-retry依赖,测试

```xml
<dependency>
    <groupId>org.springframework.retry</groupId>
    <artifactId>spring-retry</artifactId>
</dependency>
```



















