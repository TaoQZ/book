mysql

时区
mysql字段类型为datatime时,java使用时间戳Timestamp(使用IDEA自带的pojo生成工具生成时的结果),时间戳也就是UTC,从1970年01月01日 0:00:00)开始计算秒数,使用java中的new Timestamp(System.currentTimeMillis())为属性赋值插入到数据库后会少8个小时,因为我们所在的时区对UTC来说是多8个小时的,所以存的时候会少8小时

解决办法:

springboot 2.1.6.RELEASE 修改mysql的连接配置 

```yml
# serverTimezone=GMT%2b8 : mysql默认时区是UTC,修改serverTimezone意为告诉mysql服务器我使用的是哪个时区,这样存时间就会按照本地时区存储
# 只配置了这个代表着从java存储到mysql数据库时可以存储对当前系统时区来说的正常的时间,但是获取时还是会少8小时,并且还需格式化显示 ,在javabean的属性上添加注解     @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone="GMT+8"),pattern:格式化 timezone:时区,在将数据库中的数据映射到javabean上时按照指定的时区赋值

url: jdbc:mysql://127.0.0.1:3306/ols_gaosan?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=GMT%2b8&allowPublicKeyRetrieval=true
```

java获取当前系统时区

```java
ZoneId aDefault = TimeZone.getDefault().toZoneId();
System.out.println(aDefault);
// Asia/Shanghai(也可将上面连接的时区配置改为这个)
```

