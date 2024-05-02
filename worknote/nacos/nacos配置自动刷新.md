# Nacos配置自动更新



## 环境

JDK11、SpringBoot 2.3.4.RELEASE、Nacos1.4.2



## 总结

- 首先在bootstrap.yml中的nacos配置里需要设置对应的 配置文件 自动更新参数 **refresh: true**
- 在使用 @Value(“${tao.name}”) 引用配置的类上添加 **@RefreshScope** 注解，与上面 **refresh: true** 缺一不可
- 使用 static 修饰的变量拿不到引用的值
- 使用接口和实现类，在实现类中也可以达到自动刷新的效果



## 示例代码

#### controller

```java
package com.fri.commonSrv.controller;

import com.fri.commonSrv.constant.Constant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RefreshScope
@RestController
@RequestMapping(Constant.CONTEXT_PATH + "/versionInfoController")
public class HelloController {

    @Value("${tao.name}")
    private String name;

    @Value("${tao.name}")
    private static String stringname;

    @Autowired
    private Xservice xService;

    @GetMapping("/get")
    public String test() {
        return name;
    }

    @GetMapping("/getStatic")
    public String stringname() {
         return stringname;
    }

    @GetMapping("/xService")
    public String xService() {
        return xService.name();
    }
}
```



#### service

```java
@Service
@RefreshScope
public class XServiceImpl implements Xservice{

    @Value("${tao.name}")
    private String name;

    @Override
    public String name() {
        return name;
    }
}
```



#### bootstrap.yml

```yaml
spring:
  application:
  cloud:
    nacos:
      config:
        #默认为public命名空间（进行环境隔离，指定不同环境）
        namespace: @nacos.namespace@
        #服务器地址
        server-addr: @nacos.url@
        #配置文件后缀
        file-extension: yml
        shared-configs[0]: #公用配置文件
          data-id: mysql-common.yml
          refresh: true #是否支持自动刷新，默认false不支持
        shared-configs[1]:
          data-id: consul-common.yml
          refresh: true
  profiles:
    active: @profiles.active@
```



#### nacos consul-common.yml

```yaml
spring:
  cloud:
    consul:
      host: 127.0.0.1
      port: 8500
tao:
  name: gggggggggggg
```

