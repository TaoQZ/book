# 1.什么是SpringBoot?

​	简化了Spring项目的搭建和开发过程,可以整合其他框架,简单,快速,快变



# 2..SpringBoot的项目结构:	

​	其他包和boot的启动类在同一级目录

```java
com
  +- example
    +- myproject
      +- Application.java
      |
      +- model
      |  +- Customer.java
      |  +- CustomerRepository.java
      |
      +- service
      |  +- CustomerService.java
      |
      +- controller
      |  +- CustomerController.java
      |
```

​	使用idea创建的Boot项目默认给出两个依赖

​		spring-boot-starter:核心模块,包括自动配置支持、日志和 YAML

​		`spring-boot-starter-test` ：测试模块



# 3.idea中创建项目后使用创建webapp目录,以及使用jsp

​	需要添加依赖:

```xml
<!--jsp页面使用jstl标签 -->
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>jstl</artifactId>
</dependency>

<!--用于编译jsp -->
<dependency>
    <groupId>org.apache.tomcat.embed</groupId>
    <artifactId>tomcat-embed-jasper</artifactId>
    <scope>provided</scope>
</dependency>
```

​	创建webapp目录应该与Java和resources目录同级

​	标记为web目录:Modules --> 点击项目下的Web,将webapp路径添加到下图

![1561705812585](/img/springboot/使用jsp.png)



# 4.自定义过滤器:

​	其中MyFilter类自己实现javax.servlet.Filter接口![1561706000817](/img/springboot/自定义过滤器.png)

# 5.整合Mybatis:

​	**需要的依赖:**

```xml
<!--mybatis起步依赖-->
<dependency>
<groupId>org.mybatis.spring.boot</groupId>
<artifactId>mybatis-spring-boot-starter</artifactId>
    <version>1.1.1</version>
</dependency>

<!-- MySQL连接驱动 -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>

<!--   通用mapper     -->
<dependency>
    <groupId>tk.mybatis</groupId>
    <artifactId>mapper</artifactId>
    <version>3.5.2</version>
    <!--  Jpa 和 mybatis 都依赖该包会出现异常    -->
    <!--  异常信息:Correct the classpath of your application so that it contains a single, compatible version of javax.persistence.spi.PersistenceUnitInfo          -->
    <exclusions>
        <exclusion>
            <groupId>javax.persistence</groupId>
            <artifactId>persistence-api</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

​	**其中如果数据出现乱码:**

```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <!-- spring-boot:run 中文乱码解决 -->
        <jvmArguments>-Dfile.encoding=UTF-8</jvmArguments>
    </configuration>
    <!-- mvn spring-boot:repackage -->
    <executions>
        <execution>
            <goals>
                <goal>repackage</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

​	**application.yml需要的配置:**

```yaml
#com.mysql.jdbc.Driver 是 mysql-connector-java 5中的，
#com.mysql.cj.jdbc.Driver 是 mysql-connector-java 6中的
#jdbc:mysql://localhost:3306/test?serverTimezone=UTC&useUnicode=true&characterEncoding=utf8&useSSL=false
spring:
    datasource:
        url: jdbc:mysql:///study?serverTimezone=UTC
        driverClassName: com.mysql.cj.jdbc.Driver
        username: root 
        password: 123
```

```yaml
#spring集成Mybatis环境 #pojo别名扫描包
mybatis:
#执行SQL语句日志
    configuration:
      log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
    type-aliases-package: com.czxy.springboot_mybatis.domain
#加载Mybatis映射文件 在resources文件夹下创建mapper文件夹
#   mapper-locations: classpath:mapper/*.xml
#加载映射文件 在Java文件夹中的xml文件
#    mapper-locations: classpath:com/czxy/springboot_mybatis/mapper/*.xml
#加载Mybatis配置文件 还没试
#   config-location: classpath:mybatis/mybatis-config.xml
# 驼峰命名规范 如：数据库字段是  order_id 那么 实体字段就要写成 orderId
#  mybatis.configuration.map-underscore-to-camel-case=true
```

​	**1.在接口上添加@Mapper**,如果很多Mapper需要添加很多注解,可以用下面的方式,						@org.apache.ibatis.annotations.Mapper

​	**2.在启动类上添加:**

```java
// 扫描所有mapper 该注解是tk包下的
@MapperScan("com.czxy.springboot_mybatis.mapper")
```

​	**如果需要加载在java包中的映射文件,需要在pom文件中添加:**

```xml
<resources>
    <resource>
        <directory>src/main/resources</directory>
    </resource>
    <resource>
        <directory>src/main/java</directory>
        <includes>
            <include>**/*.xml</include>
        </includes>
        <filtering>true</filtering>
    </resource>
</resources>
```

​	

# **6.整合JPA:**

```yaml
#JPA Configuration:
spring:
    jpa:
      database: MySQL
      show-sql: true
      generate-ddl: true
      hibernate:
        ddl-auto: update
        naming:
          implicit-strategy: org.springframework.boot.orm.jpa.hibernate.SpringImplicitNamingStrategy
```

​	**注意事项:与mybatis一起使用时****,会引起依赖冲突**

​	**解决:****排除掉出现冲突的依赖**

```xml
<!--   通用mapper     -->
<dependency>
    <groupId>tk.mybatis</groupId>
    <artifactId>mapper</artifactId>
    <version>3.5.2</version>
    <!--  Jpa 和 mybatis 都依赖该包会出现异常    -->
    <!--  异常信息:Correct the classpath of your application so that it contains a single, compatible version of javax.persistence.spi.PersistenceUnitInfo          -->
    <exclusions>
        <exclusion>
            <groupId>javax.persistence</groupId>
            <artifactId>persistence-api</artifactId>
        </exclusion>
    </exclusions>
</dependency>

   <!-- springBoot JPA的起步依赖 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
```

# **7.使用log4j:**

​	在resources文件夹下添加log4j.properties

​	yml:

```properties
#使用log4j作为日志文件
#logging:
#  config: src/main/resources/log4j.properties
```

​	需要的依赖:需要排除boot的自带日志

```xml
        <!--   日志     -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
    <!--    SpringBoot 默认使用LogBack  如果使用log4j需要排除其依赖       -->
    <exclusions>
        <exclusion>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-logging</artifactId>
        </exclusion>
    </exclusions>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-log4j</artifactId>
    <version>1.3.8.RELEASE</version>
</dependency>
```

# 8.boot热部署:

​	**需要的依赖:**

```xml
<!--热部署配置-->
<dependency>
    <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-devtools</artifactId>
</dependency>
```

​	**properties:**

```properties
#开启热部署
spring.devtools.restart.enabled=true
#设置重启文件目录
spring.devtools.restart.additional-paths=src/main/java
#页面不加载缓存，修改即时生效
spring.thymeleaf.cache=false
```

​	**idea需要的配置:**	![1561707248382](/img/springboot/热部署1.png)

![1561707271469](/img/springboot/热部署2.png)

# 9.webjars:

​	WebJars可以让大家 以Jar 包的形式来使用前端的各种框架、组件。

​	WebJars 是将客户端（浏览器）资源（JavaScript，Css等）打成 Jar 包文件，以对资源进行统一依赖管理。WebJars 的 Jar 包部署在 Maven 中央仓库上。

​	可以让我们对前端资源也以jar包的方式进行依赖管理

**通过查看mvc的自动配置类可以看到前端资源配置的虚拟路径和映射路径**

引入时,按照其在pom文件中的 webjars/a/v/具体引入的东西

![1563239197667](/img/springboot/webjars.png)

​	官网:<https://www.webjars.org/>

​	所需依赖:

```xml
<!--Webjars版本定位工具（前端）-->
<dependency>
    <groupId>org.webjars</groupId>
    <artifactId>webjars-locator-core</artifactId>
</dependency>

<dependency>
    <groupId>org.webjars</groupId>
    <artifactId>jquery</artifactId>
    <version>3.3.1</version>
</dependency>
```

​     测试访问路径:http://localhost:8080/webjars/jquery/3.3.1/jquery.js

​     对应在jsp中引用:<script src="webjars/jquery/3.3.1/jquery.js"></script>

# 10.定时任务:

​	在启动类上添加**@EnableScheduling**启用定时任务

​	创建定时任务类并交由spring管理,在需要运行的方法上添加**@Scheduled**注解

​	**@Scheduled注解参数说明:**

`	@Scheduled`参数可以接受两种定时的设置，一种是我们常用的`cron="*/6 * * * * ?"`，一种	是`fixedRate = 6000`，两种都表示每隔六秒打印一下内容。

**fixedRate说明**

- `@Scheduled(fixedRate = 6000)` ：上一次开始执行时间点之后6秒再执行
- `@Scheduled(fixedDelay = 6000)` ：上一次执行完毕时间点之后6秒再执行
- `@Scheduled(initialDelay=1000, fixedRate=6000)` ：第一次延迟1秒后执行，之后按fixedRate的规则每6秒执行一次

# **11.@PropertySource和@ConfigurationProperties注解**

​	@PropertySource配合@Value注解使用 **前者指定配置文件名称后者使用其在配置文件中的名称注入**

​	@ConfigurationProperties **自定义一个配置文件,配合@PropertySource指定配置文件后,提供getset方法进行注入**



# 12.前后台日期格式相互转换

​	在bean类属性上添加

​	前台传递后台按照指定格式接收:

​		**方式一:@DateTimeFormat(pattern = "")**

​		**方式二:在application.properties文件中添加**

​				**spring.mvc.date-format=yyyy-MM-dd HH:mm:ss**	

​	后台返回给前台json时的data自定义格式字符串:

​		**方式一:@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone="GMT+8")**

​		**方式二:**

​		**spring.jackson.time-zone=GMT+8**

​		**spring.jackson.date-format=yyyy-MM-dd HH:mm:ss**

# 13.boot中使用拦截器

​	**ssm方式使用配置类配置拦截器在springmvc_note中**,注意spring5后一律推荐使用实现WebMvcConfigurer接口

​		创建**HandlerInterceptor**接口的实现类,并使用@Component注解将该类添加到spring容器中

​		创建**mvc的配置类,并且声明该类是配置类**,实现WebMvcConfigurer接口重写以下方法

```java
@Override
public void addInterceptors(InterceptorRegistry registry) {
    registry.addInterceptor(myInterceptor).addPathPatterns("/**").excludePathPatterns("/js/*").excludePathPatterns("/login.html").excludePathPatterns("/register.html").excludePathPatterns("/login").excludePathPatterns("/register");
}
```

​	

# 14.静态文件

​	阅读源码可以看到WebMvcAutoConfiguration 类中addResourceHandlers方法

![1563197024899](/img/springboot/静态文件1.png)

去读ResourceProperties类中的属性

![1563197067348](/img/springboot/静态文件2.png)

其中将默认的值赋值给了它,共有四个默认值,其优先级跟下图声明顺序一样

![1563197107095](/img/springboot/静态文件3.png)

这几个文件夹都是在resources文件夹下的

1. **classpath:/META-INF/resources/**

2. **classpath:/resources/**

3. **classpath:/static/**

4. **classpath:/public/**

5. **/  :   mvc添加该路径方便我们创建webapp目录    还可以添加webapp,在idea中添加该目录需要在project settings -- > models 选中项目的web**

   **有两栏添加第一个提那家web.xml路径,第二个添加webapp路径,如果jsp访问不到 如下配置,别忘记添加依赖**

   ![1563197392234](/img/springboot/静态文件4.png)

**自定义方式:**

![1563197545283](/img/springboot/静态文件5.png)

​	       使用配置文件:

​			配置文件第一行代表添加一个静态资源文件夹路径,如果没有把默认的配置加上会覆盖默认的设置

​			同时使用自定义和默认的,用英文逗号隔开即可,前面的优先级高

​		使用java配置类:

​			实现WebMvcConfigurer接口重写addResourceHandlers,可以达到相同效果

​			映射resources下的文件夹或文件以classpath:开头 classpath:/ 代表resources根目录

​			映射磁盘下的文件以file:开头 ,其中盘符写绝对路径,盘符后的 冒号 可写可不写	

​				 例如 : file:D:/temp/upload/ file:D/temp/upload/

​	**使用webapp目录,把js文件放在其根目录下,在webapp根目录和WEB-INF的jsp都可以从所在包直接引用**

​		**注意事项:这两种方式都会覆盖其默认配置,也就是说只配置了自己想要的路径,其默认的便会失效**

​				 **关于前端引入可以在webjars中查看**



​		参考博客

​			<https://www.jianshu.com/p/d40ee98b84b5>

​			<https://www.cnblogs.com/sxdcgaq8080/p/7833400.html>

​			[江南一点雨](https://mp.weixin.qq.com/s?__biz=MzI1NDY0MTkzNQ==&mid=2247485190&idx=1&sn=51df0c9e941f31bfe1cf32154445465b&scene=21#wechat_redirect)



# 15.实现页面跳转的简便化,配置类中的addViewControllers()方法

​		实现WebMvcConfigurer重写addViewControllers方法

​		registry.addViewController("/").setViewName("test.html");

​		前面是url映射路径,后面是要显示的页面,**其中setViewName()会经过视图解析器**

​		**注意事项:如果在配置类中的映射路径和在controller中的路径一样,会匹配到controller中的内容**



​	参考博客:

​	<https://www.cnblogs.com/sxdcgaq8080/p/7833400.html>



# 16.上传图片

​	前台ajax固定代码

```javascript
$(function () {
    // 当点击btn的时候
    $("#btn").click(function () {
        alert(1)
        //1 准备一个FormData对象，用来封装表单数据
        var data = new FormData();
        //2 获取上传文件
        var files = $("#myfile").prop("files");
        data.append("myfile",files[0]);
        //3 获取其余的表单元素
        data.append("username",$("#username").val());
        data.append("password",$("#password").val());
        data.append("age",$("#age").val());
        /**
         *
         * form的enctype必须是multipart/form-data才可以上传多个文件，ajax通过FormData来上传数据，ajax的cache、processData、contentType均要设置为false。
         cache设为false是为了兼容ie8，防止ie8之前版本缓存get请求的处理方式。
         contentType设置为false原因：https://segmentfault.com/a/1190000007207128。
         processData：要求为Boolean类型的参数，默认为true。默认情况下，发送的数据将被转换为对象（从技术角度来讲并非字符串）以配合默认内容类型"application/x-www-form-urlencoded"。
         如果要发送DOM树信息或者其他不希望转换的信息，请设置为false。
         *
         *
         */
        // 发送ajax
        debugger;
        $.ajax({
            url:"/register",
            type:"POST",
            data:data,
            cache:false,
            processData:false,
            contentType:false,
            success:function () {
                location.href = "login.html"
           }
        })
    });

});
```

**contentType设置为false原因：https://segmentfault.com/a/1190000007207128**



**mvc 用来处理文件上传的对象MultipartFile**

前台访问后台存储的文件,如果存储的路径是绝对路径,在前台找对应文 件路径时会找客户端电脑中的文件

如果直接在项目中直接存储,导致项目过大,在普通数据库存储也不太方便,最合适的方法在服务器存储

所以需要配置一个虚拟路径,为了在访问路径时去找我们服务器中存储文件的绝对路径

具体实现:

​	写一个配置类,实现WebMvcConfigurer接口重写**addResourceHandlers**方法

​	registry.**addResourceHandler**("/upload/**").addResourceLocations("file:D:/temp/upload/");

​	**前面是请求的路径/**代表upload下的所有的文件及文件夹**

​	**后面代表实际访问的服务器中的路径 注意要加file:**

如果想要在项目根目录下存储

​	先获得存储文件的绝对路径,再加上文件名称

```java
myfile.transferTo(new File(new File("upload").getAbsolutePath()+"/"+myfile.getOriginalFilename()));
```

​	存储在和java源文件和资源文件同目录

```java
// 获取到的是项目/target/classes/路径
File file = new File(LoginController.class.getClass().getResource("/").getPath() + "/upload");
if (!file.exists()){
    file.mkdir();
}

myfile.transferTo(new File(file.getAbsolutePath(),myfile.getOriginalFilename()));
```

​	两种方式通过maven的install安装在本地仓库,都可以拿到存储的文件

**图片太大 在application.properties中设置:**

```properties
#文件上传大小为20M
spring.servlet.multipart.max-file-size=20MB
#请求大小为20M
spring.servlet.multipart.max-request-size=20MB
```



# 17.restful结合ajax

​       首先要知道boot也是结合了mvc的,所以在后台方法进行封装时,和之前一样,只要**前台name和方法参数对应mvc会帮我们自动封装**

​	前台:在**jquery.form.js插件中有$("#myForm").formSerialize()**;方法可以直接将表单数据全部封装,直接发送请求即可

​	如果要前后台统一使用json来传输数据

​		前台:

​			**contentType:"application/json;charset=UTF-8" : ajax要指名请求头的数据格式**

​	**自定义方法**,将表单数据转换为json格式的字符串,最后使用js自身的方法JSON.stringify($("#myForm").serializeJson()) 作为data传递到后台		

```javascript
$.fn.serializeJson=function() {
    var serializeObj = {};
    var array = this.serializeArray();
    var str = this.serialize();
    $(array).each(function () {
        if (serializeObj[this.name]) {
            if ($.isArray(serializeObj[this.name])) {
                serializeObj[this.name].push(this.value);
            } else {
                serializeObj[this.name] = [serializeObj[this.name], this.value];
            }
        } else {
            serializeObj[this.name] = this.value;
        }
    });
    return serializeObj;
};
```

​	**如果前台跳转页面时,在地址栏传递信息,可以使用以下代码获取**

```javascript
// 获取id
var a = location.search
var b = location.search.split("=")
var c = location.search.split("=")[1]
// var d=  parseInt((location.search.match(/id=\w+/)[0]).split("=")[1])
var id = parseInt(location.search.split("=")[1]);
```

​	**由于ajax请求不支持转发页面所以需要在前台跳转**

​	**在ajax请求成功后  window.location.href = "地址"**

​	

# 18.路径映射:

​	<https://blog.csdn.net/zhou920786312/article/details/81026381>



# 19.mysql驱动包 8.x 修改时区

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/study?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC
```



# **20.application.yml: **

​	**注意name和value之间要有一个空格**

```yml
person:
    name: zhangsan
#DB Configuration: 数据源
spring:
    datasource:
        url: jdbc:mysql:///study?serverTimezone=UTC
        driverClassName: com.mysql.cj.jdbc.Driver
        username: root 
        password: 123
    devtools: #热部署
        restart:
            enabled: true
            additional-paths: src/main/java
    mvc: #mvc
      view:
        prefix: /WEB-INF/view/
        suffix: .jsp
#JPA Configuration:
    jpa:
      database: MySQL
      show-sql: true
      generate-ddl: true
      hibernate:
        ddl-auto: update
        naming:
          implicit-strategy: org.springframework.boot.orm.jpa.hibernate.SpringImplicitNamingStrategy

#spring集成Mybatis环境 #pojo别名扫描包
mybatis:
    type-aliases-package: com.czxy.springboot_mybatis.domain
#加载Mybatis映射文件
#   mapper-locations: classpath:mapper/*.xml
#加载Mybatis配置文件
#   config-location: classpath:mybatis/mybatis-config.xml


#配置默认端口以及默认项目路径
#server:
#  port: 8888
#  servlet:
#    context-path: /demo

#使用log4j作为日志文件
#logging:
#  config: src/main/resources/log4j.properties
```

