创建微服务pojo类所需依赖

```xml
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    <java.version>1.8</java.version>
    <mybatis.starter.version>1.3.2</mybatis.starter.version>
    <mapper.starter.version>2.0.2</mapper.starter.version>
    <druid.starter.version>1.1.9</druid.starter.version>
    <mysql.version>5.1.32</mysql.version>
    <pageHelper.starter.version>1.2.3</pageHelper.starter.version>
    <jjwt.version>0.7.0</jjwt.version>
    <joda-time.version>2.9.6</joda-time.version>
</properties>

<dependencies>

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
    <!--        mybatis分页插件-->
    <dependency>
        <groupId>com.github.pagehelper</groupId>
        <artifactId>pagehelper-spring-boot-starter</artifactId>
        <version>${pageHelper.starter.version}</version>
    </dependency>
    <!-- druid启动器 -->
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
    <!--        jwt所需依赖-->
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt</artifactId>
        <version>${jjwt.version}</version>
    </dependency>
    <!-- https://mvnrepository.com/artifact/joda-time/joda-time -->
    <dependency>
        <groupId>joda-time</groupId>
        <artifactId>joda-time</artifactId>
        <version>${joda-time.version}</version>
    </dependency>

</dependencies>
```

