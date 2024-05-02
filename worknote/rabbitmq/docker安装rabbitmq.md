docker安装rabbitmq

拉取镜像

```
docker pull rabbitmq
```

创建容器并运行

15672: web管理页面		5672: 数据通信端口		rabbitmq: 镜像名称

```
 docker run -itd --name myrabbitmq -p 15672:15672 -p 5672:5672 rabbitmq
```

启动管理页面

myrabbitmq: 容器名称

```
docker exec -it myrabbitmq rabbitmq-plugins enable rabbitmq_management
```

默认账号密码

```
username: guest
password: guest
```

清空rabbitmq中的所有队列和交换机

```shell
# 进入容器
docker exec -it 容器ID /bin/bash
# 进入容器 /sbin 目录
# 关闭应用
rabbitmqctl stop_app
# 清除
rabbitmqctl reset
# 重启
rabbitmqctl start_app
```

rabbitmq使用过程中遇到的问题
1.再使用docker安装rabbitmq时,还需要启动其内置的管理程序
2.再结合springboot使用传递对象时,对象的全路径名称要一致,否则序列化失败,也可以转为json字符串传输
3.注册TopicExchange

```java
// 报错
@Bean
public TopicExchange exchange() {
    return new TopicExchange("exchange");
}
// 正常
@Bean
public TopicExchange topicExchange() {
    return new TopicExchange("exchange");
}
```

交换机
Direct : 默认,进行路由键的全值匹配
Topic: 和Direct类似,在Diret的基础上添加模糊匹配机制,名称使用**.**分割,*****代表一个指定的字符,**#**代表零个或多个字符
Fanout: 广播模式,无视路由键和路由模式,会将消息发送给绑定至该交换机的所有队列,如果配置了routing_key会被忽略

```
http://www.ityouknow.com/springboot/2016/11/30/spring-boot-rabbitMQ.html
```

