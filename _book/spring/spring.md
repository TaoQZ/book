# Spring

​			context包提供了IOC容器功能

​			IOC就是一个大的Map集合,key就是name,value就是对象

### 	XML方式

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

        <bean id="user" class="xyz.taoqz.one.domain.User">
            <property name="name" value="zzz"/>
            <property name="age" value="18"/>
        </bean>

</beans>
```

```java
public class XmlTest {

    @Test
    public void demo(){
        ClassPathXmlApplicationContext classPathXmlApplicationContext = new ClassPathXmlApplicationContext("beans.xml");
        Object user = classPathXmlApplicationContext.getBean("user");
        System.out.println(user);
    }

}
```



### 注解方式

```java
// 使用注解方式的配置类
@Configuration
public class SpringConfig {
	// 可以自定义name,默认是方法名
    @Bean
    public User getUser(){
        return new User();
    }

}
```

```java
public class AnnoTest {

    @Test
    public void demo(){
        AnnotationConfigApplicationContext app = new AnnotationConfigApplicationContext(SpringConfig.class);
        User user = (User) app.getBean("getUser");
        System.out.println(user);

        // 根据类获取该类在容器中的name
        String[] beanNamesForType = app.getBeanNamesForType(User.class);

        // 获取容器中所有的name
        String[] names = app.getBeanDefinitionNames();
    }
    
}
```



### @ComponentScan

​		该注解写在配置类用于扫描其他其他包中的组件@Controller  @Service  @Repository 这三个组件最顶层是@Component

​		默认的name是类名首字母小写

​		通过该注解扫描得到的Bean和在配置类中使用@Bean注解得到的Bean是一个级别的



```java
// 扫描时进行包含过滤,过滤类型默认为注解,classes的值则是最后包含的组件
// 需要将默认的过滤方式禁用 false
// FilterType 常用类型还有自定义 也就是指定哪些类 ASSIGNABLE_TYPE
// useDefaultFilters的作用是 是否开启扫描其他组件默认为true 包含时设置为false,排除某个类型时为true
@Configuration
@ComponentScan(value = "xyz.taoqz.two",includeFilters = {
        @ComponentScan.Filter(type = FilterType.ANNOTATION,classes = {Controller.class})
},useDefaultFilters = false)

//
public class SpringConfig {

}
```

#### 	主要属性

```java
value：指定要扫描的package；
includeFilters=Filter[]：指定只包含的组件
excludeFilters=Filter[]：指定需要排除的组件；
useDefaultFilters=true/false：指定是否需要使用Spring默认的扫描规则：被@Component, @Repository, @Service, @Controller或者已经声明过@Component自定义注解标记的组件；

在过滤规则Filter中：
FilterType：指定过滤规则，支持的过滤规则有
ANNOTATION：按照注解规则，过滤被指定注解标记的类；
ASSIGNABLE_TYPE：按照给定的类型；
ASPECTJ：按照ASPECTJ表达式；
REGEX：按照正则表达式
CUSTOM：自定义规则；
value：指定在该规则下过滤的表达式；
```


### 	自定义一个扫描过滤类TypeFilter		

```java
过滤类:
public class CustomTypeFilter implements TypeFilter {

    /**
     * 读取到当前正在扫描类的信息
     * @param metadataReader
     * 可以获取到其他任何类的信息
     * @param metadataReaderFactory
     * @return
     * @throws IOException
     */
    @Override
    public boolean match(MetadataReader metadataReader, MetadataReaderFactory metadataReaderFactory) throws IOException {
        // 获取当前类注解的信息
        AnnotationMetadata annotationMetadata = metadataReader.getAnnotationMetadata();
        // 获取当前正在扫描的类信息
        ClassMetadata classMetadata = metadataReader.getClassMetadata();
        // 获取当前类路径
        Resource resource = metadataReader.getResource();

        System.out.println(classMetadata.getClassName());

        // 可以在此处进行判断,根据类信息进行过滤

        return false;
    }
}

配置类:
@Configuration
@ComponentScan(value = "xyz.taoqz.two",includeFilters = {
    	// 将过滤类型改为CUSTOM自定义,classes的值为自定义的过滤类
        @ComponentScan.Filter(type = FilterType.CUSTOM,classes ={CustomTypeFilter.class})
},useDefaultFilters = false)
public class SpringConfig {

}
```

​	

### 	@ComponentScans

```java
// (可以声明多个@ComponentScan)
@ComponentScans({@ComponentScan("xyz.taoqz"),
                @ComponentScan(value = "xyz.taoqz.two",includeFilters = {
                        @ComponentScan.Filter(type = FilterType.CUSTOM,classes = {CustomTypeFilter.class})
                },useDefaultFilters = false)
                })
public class SpringConfig {

}
```



### 	@Scope作用域	

```java

@Configuration
public class SpringConfig {

    // 无论是使用@Bean还是其他组件的注解,默认都是单例的
    @Bean
    /**
     * 更改作用域
     * singleton: 单实例,IOC容器启动时会调用方法创建对象并放到IOC容器中,以后获取时拿的是同一个对象
     * prototype: 多实例,IOC容器启动时并不会调用方法创建对象,而是每次使用时用方法创建对象
     * request: 一个请求一个实例
     * session: 同一个会话一个实例
     */
    @Scope("PROTOTYPE")
    public User getUser(){
        return new User();
    }

}
```

 

### 	@Lazy懒加载

​			懒加载:主要针对单例Bean在容器启动时创建对象,设置懒加载后,容器启动后不再创建对象,但是可以在容器中获取其beanname,在第一次使用时才会创建对象初始化

​			如何使用懒加载?

​				在@Bean注解或者其他组件上添加@Lazy注解

​			代码示例:

```java
@Configuration
public class SpringConfig {

    @Bean
    @Lazy
    public User getUser(){
        System.out.println("向容器中添加对象");
        return new User();
    }

}
```

```java
public class LazyTest {

    @Test
    public void fun(){

        AnnotationConfigApplicationContext app = new AnnotationConfigApplicationContext(SpringConfig.class);
        System.out.println("容器创建完成");
        app.getBean("getUser");

    }
}
```

console:

```java
	容器创建完成
	向容器中添加对象
```

使用懒加载后,会先创建容器,然后在获取Bean时才会向容器中添加对象并获得



### 	@Conditional条件注册Bean

​			@Conditional(Class<? extends Condition> [] value())

​			写在类上表示该类或者该配置类下所有Bean必须符合条件才会注册,和@Bean一起写在方法上表示该方法返回值能否注册

​			该注解的参数是一个Condition的实现类,实现其方法,可以判断Bean满足需求时进行注册

```java
public class MyCondition implements Condition {

    /**
     * 判断条件可以使用的上下文(环境0
     * @param context
     * 注解的信息
     * @param metadata
     * @return
     */
    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {

        // 可以在此处进行逻辑判断 返回true时Bean实例才会注入到容器中

        return false;
    }

}
```



### 	@Import注册Bean

​			@Import(Class<?> [] value()) : 参数时要注册的Bean的class数组

#### 			回顾注册Bean的几种常用的方式

​	1.在配置中使用@Bean的方式将方法的返回值注册到容器中,通常是使用第三方类库时使用使用组件加包扫描的方式,一般用于自定义	

​	2.组件注解:@Component @Controller @Service @Repository		

​	   包扫描:@ComponentScan(组件注解所在的包)	

​           此方法优先级高于Import方式使用@Import注解

​	3.使用@Import方式注册的Bean其name是类全路径(包名+类名)

​      	回顾使用其他方式时的name(没有指定名称的情况下)		

​                     @Bean : 方法名		

​                     组件 : 类首字母小写

​	4.使用FactoryBean 下方有解释

#### ImportSelector自定义注册Bean

```java
// 在配置类中添加 @Import(value = {MyImportSelector.class})

public class MyImportSelector implements ImportSelector {

    @Override
    public String[] selectImports(AnnotationMetadata importingClassMetadata) {

        // 返回需要注册到容器中的Bean的全类名数组
        return new String[0];

    }

}
```



#### 	ImportBeanDefinitionRegistrar手动注册Bean

```java
// 在配置类中添加
// @Import(value = {MyImportBeanDefinitionRegistrar.class})

public class MyImportBeanDefinitionRegistrar implements ImportBeanDefinitionRegistrar {

    /**
     * 当前类的注解信息
     * @param importingClassMetadata
     * BeanDefinition注册类
     *      把所有需要添加到容器中的Bean加入
     * @param registry
     */
    @Override
    public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata, BeanDefinitionRegistry registry) {

        // 该方法可以判断容器中是否有指定name的Bean
       registry.containsBeanDefinition("");

       // 使用该方式注册Bean时,需要手动给出Bean的信息 Spring提供了RootBeanDefinition类
       // 调用注册Bean的方法手动将Bean的name 和 信息注册到容器中
       // IDEA中双击Shift键 搜索DefaultListableBeanFactory 类 会调用该类中的registerBeanDefinition将Bean注册到容器中
       RootBeanDefinition rootBeanDefinition = new RootBeanDefinition(Animal.class);
       registry.registerBeanDefinition("animal",rootBeanDefinition);

    }
}
```



### FactoryBean

​	如果想创建一个工厂类,用来灵活的创建对象并且想要交由Spring管理,可以使用该类

​	需要注意的是getBean时获取的对象并不是Factory本身,而是其getObject()方法的返回值返回的具体类型

​		想要获取该类对象在getBean()中的beanname参数前加&,底层在获取对象时会先判断beanname是否以&开头

​	使用方式:实现改接口,并且重写方法,将该类注入到容器中

```java
Object getObject() : 该方法则为实际返回的对象

Class<?> getObjectType() : 对象的类型

boolean isSingleton() : 表示对象注入容器时是否单例
```



## 

​	

### 	Bean的声明周期

​			创建     :  构造方法

​			初始化 :  指定的初始化方法

​			销毁     :  指定的销毁方法   

​					会在容器关闭或移除对象时执行

​					创建和初始化会在容器创建完成前

### 	自定义初始化销毁方法

​		xml方式

```xml
<bean id="person" class="xyz.taoqz.spring_bean.Person" init-method="init" destroy-method="destroy">
</bean>
```

​		注解方式1

```java
@Bean(initMethod = "初始化方法名",destroyMethod = "销毁方法名")
public Person person(){
    return new Person();
}
```

​		注解方式2

​			**属于JDK的注解**

​			**@PostConstruct : 初始化方法**

​			**@PreDestroy : 销毁方法**	

```java
@Component
public class Person {
    public Person() {
        System.out.println("创建Person");
    }

    // 对象创建并赋值后调用
    @PostConstruct
    public void init(){
        System.out.println("Person 初始化");
    }

    // 容器移除对象调用
    @PreDestroy
    public void destory(){
        System.out.println("Person销毁");
    }
}
```

​	spring 提供的接口

​		InitializingBean, DisposableBean : 实现该接口完成init和destroy	



​	注意:只有单实例在容器创建时才会执行Bean的创建和初始化,并添加到容器中

​		 多实例只有在获取Bean时才会执行



### BeanPostProcessor接口

​	实现该接口可以在对象创建完成后的初始化方法前后进行增强

​	spring底层有很多实现该接口的类(处理器),功能包括bean的赋值,注入其他组件,生命周期注解功能等



## 



### 	@Value 赋值

​		1.普通赋值,直接在组件的成员变量上声明该注解并且赋值(字符串),同时支持springEL表达式完成计算

​					例如  @Value("#{1*3}") 在获取时便可得到该表达式的结果

​		2.使用.properties文件+@PropertySource(文件名数组)注解	

​			@Value("${属性名在文件中的key}") 	

​			在配置类上声明@PropertySource(value = {"文件名"})

```java
AnnotationConfigApplicationContext app = new AnnotationConfigApplicationContext(SpringConfig.class);

// 获取环境
ConfigurableEnvironment environment = app.getEnvironment();
// 获取所有配置文件
MutablePropertySources propertySources = environment.getPropertySources();
for (PropertySource<?> propertySource : propertySources) {
    System.out.println("获取每一个配置文件名称"+propertySource.getName());
    System.out.println("获取每一个文件中的所有的属性及属性值"+propertySource.getSource());
    System.out.println("获取指定属性名称的属性值 没有则为null"+propertySource.getProperty("name"));
}
```

### 	

### 	关于自动装配

#### 			@Autowired

​				@Autowired默认根据变量名作为beanname获取,如果没有则根据类型查找,@Autowired本身不能根据beanname指定

获取容器中的实例对象,需要配合使用@Qualifier(beanname)

​						**required属性**

​						属性值为true表示注入的时候，容器中该bean必须存在，否则就会注入失败。

​						属性值为false：表示忽略当前要注入的bean，如果有直接注入，没有跳过，不会报错



#### 			@Resource

​				jdk提供的@Resource(name = beanname)注解可以指定名称,默认根据变量名作为beanname获取,如果没有则根据类型查找,不支持required,不支持优先级



#### 			@Primary

​				设置获取bean时的优先级,可以在类上添加,也可以配合@Bean使用

​					使用@Autowired注解进行依赖注入时便会使用声明该注解的实例,@Resource不会起作用

​					比如一个接口有两个实现类,都会被扫描进容器,但是在使用接口进行注入时会报错,如果给

其中一个实现类添加优先级,会解决该问题并且优先使用该实现类

​				

#### 			@Inject

​				是Java JSR330的规范,和@Autowired功能类似,支持@Primary优先级,区别是没有required属性

```xml
<dependency>
    <groupId>javax.inject</groupId>
    <artifactId>javax.inject</artifactId>
    <version>1</version>
</dependency>
```

​			

**如果@Bean的方法名或者name相同于类首字母小写或者注解中的beanname会优先使用 @Bean产生的实例此效果三种注解相同**

**如果同时声明了@Qualifier(beanname1)+@Autowired和@Primary+@Bean(beanname2):会使用beanname1**

#### 	注入顺序

 		**@Qualifier >  优先级 > 变量名(同名@Bean优先) > 类型**  



## 

#### 		AOP

​			面向切面编程(底层使用动态代理)

​			在程序运行期间动态,在不修改源码的基础上，对已有方法进行增强。		

​		使用aop需要的依赖

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-aspects</artifactId>
    <version>5.1.8.RELEASE</version>
</dependency>
```

​			

##### 		相关术语:

​			Target(目标对象):被增强方法的所属对象

​        	        Joinpoint(连接点):目标方法可增强的位置

​			Pointcut(切入点):实际被增强的方法

​			Advice(通知/增强):对切入点增强的位置及方法

​			Aspect(切面):切入点的通知的结合()

​			Proxy(代理):一个类被AOP织入增强后,会产生一个结果代理类

##### 		相关注解:

| **注解**        | **描述**                                                     |      |
| --------------- | ------------------------------------------------------------ | ---- |
| @Aspect         | 把当前类声明成切面类                                         |      |
| @Before         | 把当前方法看成是前置通知                                     |      |
| @AfterReturning | 把当前方法看成是返回通知,需要方法正常返回。                  |      |
| @AfterThrowing  | 把当前方法看成是异常通知,方法参数可以拿到                    |      |
| @After          | 把当前方法看成是后置(最终)通知,,无论是否出现异常都会执行     |      |
| @Around         | 把当前方法看成是环绕通知                                     |      |
| @Pointcut       | 定义方法声明该注解添加切入点表达式,可以直接引用该方法作为表达式,相当于提取 |      |

##### 		切入点表达式:

```java
    //切入点表达式：execution后小括号中寻找要增强方法的表达式
//    @Before("execution(public void com.czxy.demo03.*.save())")  //某个包下的所有类用*
//    @Before("execution(void com.czxy.demo03.*.save())")  //访问权限可以省略
//    @Before("execution(* com.czxy.demo03.*.save())")  //任意返回值
//    @Before("execution(* *.*.*.*.save())")  //任意包
//    @Before("execution(* com..*.save())")  //当前包下的任意包
//    @Before("execution(* com..*.*())")  //任意方法名称
//    @Before("execution(* com..*.*(*))")  //任意方法参数必须有
//    @Before("execution(* com..*.*(..))")  //任意方法任意参数均可
//    @Before("execution(* *..*.*(..))")  //项目中所有方法
```

​	

##### 		基本使用步骤:

​			1.导入spring aop 的相关依赖

​			2.声明一个切面类 添加@Aspect @Component 注解

​			3.在切面类中编写增强方法,并添加相关通知注解以及所需切入点

​			4.在配置类中添加@EnableAspectJAutoProxy 注解开启切面

##### 		注意事项:

​			关于@Around  注解的使用

​				声明该注解后方法会默认有一个JoinPoint/ProceedingJoinPoint形参

​					将joinpoint强转为proceedingJoinPoint,并调用其pjp.proceed();方法

​				在该方法调用前执行的就是前置通知,之后则是后置通知

​				可以使用ty{}catch()finally{}做出异常通知和最终通知的效果	

```java
@Around("execution(public void com.czxy.demo03.OrderDao.save())")
public void myAround(JoinPoint joinPoint,ProceedingJoinPoint proceedingJoinPoint) {
    //获取目标对象
    Object target = joinPoint.getTarget();
    System.out.println(target);
    //获取切点方法
    Signature signature = joinPoint.getSignature();
    System.out.println(signature);

    //将joinpoint强转为proceedingJoinPoint
    ProceedingJoinPoint pjp = (ProceedingJoinPoint)joinPoint;
    try {
        System.out.println("之前？");
        pjp.proceed();
        System.out.println("之后？");
    } catch (Throwable throwable) {
        System.out.println("异常出现啦！");
        throwable.printStackTrace();
    } finally {
        System.out.println("最终执行的！");
    }
}
```



​		关于@Pointcut的使用

```java
    //设置公共切点，可以方便其他增强使用，这里bf方法与ar方法使用了该公共切点
    @Pointcut(需要提取的切入点的表达式)
    private void myPointcut(){
    }

    @Before("切面类.myPointcut()")
//    @AfterReturning("myPointcut()")
    public void bf() {
        System.out.println("增强");
    }
```



##### 切面类示例代码

```java
//日志切面类
@Aspect
public class LogAspects {
   @Pointcut("execution(public int com.enjoy.cap10.aop.Calculator.*(..))")
   public void pointCut(){};
   
   //@before代表在目标方法执行前切入, 并指定在哪个方法前切入
   @Before("pointCut()")
   public void logStart(JoinPoint joinPoint){
      System.out.println(joinPoint.getSignature().getName()+"除法运行....参数列表是:{"+ Arrays.asList(joinPoint.getArgs())+"}");
   }
   @After("pointCut()")
   public void logEnd(JoinPoint joinPoint){
      System.out.println(joinPoint.getSignature().getName()+"除法结束......");

   }
   @AfterReturning(value="pointCut()",returning="result")
   public void logReturn(Object result){
      System.out.println("除法正常返回......运行结果是:{"+result+"}");
   }
//
   @AfterThrowing(value="pointCut()",throwing="exception")
   public void logException(Exception exception){
      System.out.println("运行异常......异常信息是:{"+exception+"}");
   }

   @Around("pointCut()")
   public Object Around(ProceedingJoinPoint proceedingJoinPoint) throws Throwable{
      System.out.println("@Arount:执行目标方法之前...");
      Object obj = proceedingJoinPoint.proceed();//相当于开始调div地
      System.out.println("@Arount:执行目标方法之后...");
      return obj;
   }
}
```



##### 执行顺序

​	@Around之前 > @Before > 切入点(目标方法) > @Around之后(如抛出异常不执行) > @After > @AfterThrowing(程序抛出异常) > @AfterReturning(成功返回,如抛出异常不执行)

​	



#### 		什么是声明式事务?

​			以方法为单位,进行事务控制,抛出异常,事务回滚

​			最小的执行单位为方法,决定执行成败通过是否抛出异常来判断,抛出异常即执行失败

## 	     spring使用事务		

​		导入相关依赖:

```java
<!--        mysql驱动-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.47</version>
        </dependency>
<!--        连接池-->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid</artifactId>
            <version>1.1.10</version>
        </dependency>
<!--        jdbcTemplate-->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>5.1.8.RELEASE</version>
        </dependency>
```

​		配置类

```java
package xyz.taoqz.config;

import com.alibaba.druid.pool.DruidDataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

/**
 * @author :almostTao
 * @date :Created in 2019/9/7 15:13
 */
@Configuration
@ComponentScan("xyz.taoqz")
// 开启事务 配合@Transactional注解以及事务管理器使用
@EnableTransactionManagement
public class SpringConfig {

    /**
     * 配置数据源
     * @return
     */
    @Bean
    public DataSource dataSource(){
        DruidDataSource druidDataSource = new DruidDataSource();
        druidDataSource.setUsername("root");
        druidDataSource.setPassword("123");
        druidDataSource.setUrl("jdbc:mysql:///spring_day08_shiwu");
        druidDataSource.setDriverClassName("com.mysql.jdbc.Driver");
        return  druidDataSource;
    }

    /**
     * 实现简单的增删改查
     * @param dataSource
     * @return
     */
    @Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource){
        return new JdbcTemplate(dataSource);
    }

    /**
     * 事务管理器
     * @param dataSource
     * @return
     */
    @Bean
    public DataSourceTransactionManager txManager(DataSource dataSource){
        return new DataSourceTransactionManager(dataSource);
    }

}
```

​	 dao依赖注入

```java
@Autowired
private JdbcTemplate jdbcTemplate;
```

​	@Transactional

​		添加在方法上,表示该方法有事务效果

​		添加在类上,表示该类中所有方法都有事务

## 	

### 	自定义配置 

应该实现WebMvcConfigurer接口还是继承WebMvcConfigurerAdapter类,该类是接口的一个实现类.为了解决需要单独配置其

中一项而需要实现接口中的所有方法而产生,但在spring5之后该接口中的方法定义为default,可以选择重写方法,因此推荐使用实

现WebMvcConfigurer接口+@EnableWebMvc的方式

<https://docs.spring.io/spring/docs/5.2.1.RELEASE/spring-framework-reference/web.html#mvc-config-enable>

​	





























FactoryBean和BeanFactory的区别

​	FactoryBean:将java实例注入到容器中

​	BeanFactroy:从容器中获取实例化后的Bean  

#### 