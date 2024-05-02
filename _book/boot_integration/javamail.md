# JavaMail

在用户登录注册或者进行其他操作时,除了手机号码还可以提供另一种处理方式,就是使用JavaMail,并且该方式也是完全免费的。

需要在不同邮箱提供商的设置POP3/SMTP/IMAP中开启IMAP/SMTP和POP3/SMTP服务



## 使用

结合springboot项目使用

### 依赖

```xml
<!-- 导入javamail的坐标 -->
<dependency>
    <groupId>javax.mail</groupId>
    <artifactId>mail</artifactId>
    <version>1.4.7</version>
</dependency>

<!-- 简化实体类      -->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
</dependency>
```

### 创建javamail.yml

```yml
javamail:
  smtp_host: smtp.163.com
  username: 具体邮箱@163.com
  password: 授权码,并不是邮箱密码,在邮箱设置处获取
  # 和username使用同一个邮箱地址即可
  from: 具体邮箱@163.com
```

### 创建配置类

```java
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

/**
 * @author :almostTao
 * @date :Created in 2020/4/9 16:31
 */
// 简化getters setters
@Data
// 指定配置文件名称
@PropertySource(value = "classpath:javamail.yml")
// 默认使用application.properties 文件 prefix指定前缀
@ConfigurationProperties(prefix = "javamail")
// 表名该类是一个配置类
@Configuration
public class JavaMailConfig {
    public String smtp_host ;
    public String username ;
    public String password ;
    public String from ;
}
```

### 创建工具类

```java
/**
 * @author :almostTao
 * @date :Created in 2020/4/9 16:19
 */
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import xyz.taoqz.config.JavaMailConfig;

import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;
import java.util.Properties;

// 启动时可以被spring扫描并添加到容器中
@Component
public class MailUtil {

    // 注入配置类
    @Autowired
    private JavaMailConfig javaMailConfig;

    // 发送邮件主要方法
    public void sendMail(String to, String subject, String text) throws Exception {
        // 1 准备发送邮件需要的参数
        Properties props = new Properties();
        // 设置主机地址 smtp.qq.com smtp.126.com smtp.163.com
        props.put("mail.smtp.host",javaMailConfig.smtp_host);
        // 是否打开验证:只能设置true，必须打开
        props.put("mail.smtp.auth", true);

        // 2 连接邮件服务器
        Session session = Session.getDefaultInstance(props);
        // 3 创建邮件信息
        MimeMessage message = new MimeMessage(session);

        // 4 设置发送者
        InternetAddress fromAddress = new InternetAddress(javaMailConfig.from);
        message.setFrom(fromAddress);
        // 5 设置接收者
        InternetAddress toAddress = new InternetAddress(to);
        // to:直接接收者 cc：抄送 bcc暗送
        message.setRecipient(RecipientType.TO, toAddress);
        // 6 设置主题
        message.setSubject(subject);
        // 7 设置正文
        message.setText(text);

        // 设置HTML方式发送
        //message.setContent(text, "text/html;charset=utf-8");

        // 8 发送:坐火箭
        Transport transport = session.getTransport("smtp");// 参数不能少，表示的是发送协议
        // 登录邮箱,此处的密码是授权码
        transport.connect(javaMailConfig.username,javaMailConfig.password);
        transport.sendMessage(message, message.getAllRecipients());
        transport.close();

        System.out.println("ok");
    }

}
```

### 测试

```java
@SpringBootTest
class JavamailDemoApplicationTests {

    @Test
    void contextLoads() {
    }

    @Autowired
    private MailUtil mailUtil;

    @Test
    public void demo(){
        try {
            mailUtil.sendMail("xxx@qq.com", "激活测试", "test");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Autowired
    private JavaMailConfig javaMailConfig;

    @Test
    public void demo2(){
        System.out.println(javaMailConfig);
    }

}
```

