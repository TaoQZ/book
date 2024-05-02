# 什么是Mybatis

Mybatis是一个持久层ORM框架。内部封装了jdbc，使开发更简洁，更高效。

Mybatis使开发者只需要关注sql语句本身，简化JDBC操作，不需要在关注加载驱动、创建连接、处理SQL语句等繁杂的过程。

Mybatis可以通过xml或注解完成ORM映射关系配置。



# 什么是ORM

ORM的全称是Object Relational Mapping，即对象关系映射。

描述的是对象和表之间的映射。操作Java对象，通过映射关系，就可以自动操作数据库。

在ORM关系中，数据库表对应Java中的类，一条记录对应一个对象，一个属性对应一个列。

常见的ORM框架：Mybatis、Hibernate



# 案例

该例子主要为了结合springboot、example以及PageHelper分页使用

pom.xml

```xml
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.2.5.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    
      <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
        <mybatis.starter.version>1.3.2</mybatis.starter.version>
        <mapper.starter.version>2.0.2</mapper.starter.version>
        <druid.starter.version>1.1.9</druid.starter.version>
        <mysql.version>5.1.32</mysql.version>
        <pageHelper.starter.version>1.2.3</pageHelper.starter.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!--简化实体类-->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
        </dependency>
        <!-- mybatis启动器 -->
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>${mybatis.starter.version}</version>
        </dependency>
        <!-- 通用Mapper启动器 -->
        <dependency>
            <groupId>tk.mybatis</groupId>
            <artifactId>mapper-spring-boot-starter</artifactId>
            <version>${mapper.starter.version}</version>
        </dependency>
        <!--   mybatis分页插件-->
        <dependency>
            <groupId>com.github.pagehelper</groupId>
            <artifactId>pagehelper-spring-boot-starter</artifactId>
            <version>${pageHelper.starter.version}</version>
        </dependency>
        <!-- druid连接池 -->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid-spring-boot-starter</artifactId>
            <version>${druid.starter.version}</version>
        </dependency>
        <!--        mysql驱动-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>${mysql.version}</version>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
            <exclusions>
                <exclusion>
                    <groupId>org.junit.vintage</groupId>
                    <artifactId>junit-vintage-engine</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
    </dependencies>
```

application.yml

```yml
server:
  port: 10400
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/数据库?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
    username: root
    password: 123
    driver-class-name: com.mysql.jdbc.Driver
#    德鲁伊连接池
    druid:
#      初始化大小,最小,最大
      initial-size: 5
      min-idle: 5
      max-active: 20
#      获取连接等待超时的时间
      max-wait: 60000
#      配置一个连接在池中最小生存的时间,单位是毫秒
      min-evictable-idle-time-millis: 300000
  application:
    name: book
mybatis:
  configuration:
#    在控制台输出sql日志
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
#    指定xml文件位置
  mapper-locations: classpath:mapperxml/*.xml

```

BookMapper.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="xyz.taoqz.mapper.BookMapper">
  <resultMap id="BaseResultMap" type="xyz.taoqz.domain.Book">
    <!--@mbg.generated generated on Tue Mar 17 15:56:55 CST 2020.-->
    <id column="id" jdbcType="INTEGER" property="id" />
    <result column="book_name" jdbcType="VARCHAR" property="bookName" />
    <result column="produce_date" jdbcType="TIMESTAMP" property="produceDate" />
    <result column="book_pub" jdbcType="VARCHAR" property="bookPub" />
    <result column="book_num" jdbcType="INTEGER" property="bookNum" />
  </resultMap>
  <sql id="Base_Column_List">
    <!--@mbg.generated generated on Tue Mar 17 15:56:55 CST 2020.-->
    id, book_name, produce_date, book_pub, book_num
  </sql>

  <select id="findByIds" resultMap="BaseResultMap">
    SELECT
     <include refid="Base_Column_List"></include>
    from book
    WHERE id IN
    <foreach collection="array" item="id" index="index" open="(" close=")" separator=",">
      #{id}
    </foreach>
  </select>

</mapper>
```

mapper

```java
public interface BookMapper extends Mapper<Book> {
    List<Book> findByIds(String[] bookIds);
}
```

service

```java
@Service
public class BookService{

    @Resource
    private BookMapper bookMapper;

    public List<Book> findAll() {
        return bookMapper.selectAll();
    }

    public List<Book> findByIds(String[] ids) {
        return bookMapper.findByIds(ids);
    }

    public List<Book> findByPage(Integer pageNum,Integer pageSize) {
        PageHelper.startPage(pageNum,pageSize);
        Example example = new Example(Book.class);
        example.createCriteria().orIsNotNull("bookPub");
        return bookMapper.selectByExample(example);
    }
}

```

controller

```java
@RequestMapping("/book")
@RestController
public class BookController {

    @Autowired
    private BookService bookService;

    @GetMapping("/findByIds")
    public List<Book> findByIds(String[] ids){
        System.out.println(Arrays.toString(ids));
        return bookService.findByIds(ids);
    }

}
```

domain

```java
@Data
@Table(name = "book")
public class Book {
    @Id
    @Column(name = "id")
    @GeneratedValue(generator = "JDBC")
    private Integer id;

    @Column(name = "book_name")
    private String bookName;

    // 传入数据库的格式
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    // 返回数据的格式
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
    @Column(name = "produce_date")
    private LocalDate produceDate;

    @Column(name = "book_pub")
    private String bookPub;

    @Column(name = "book_num")
    private Integer bookNum;
}
```