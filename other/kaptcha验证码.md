# Kaptcha

Kaptcha是一个高度可配置的生成验证码的工具



## 结合springboot使用

### 依赖

```xml
<dependency>
    <groupId>com.google.code.kaptcha</groupId>
    <artifactId>kaptcha</artifactId>
    <version>2.3</version>
</dependency>
```

### 配置类

```java
@Configuration
public class KaptchaConfig {
    @Bean
    public DefaultKaptcha getDefaultKaptcha(){
        com.google.code.kaptcha.impl.DefaultKaptcha defaultKaptcha = new com.google.code.kaptcha.impl.DefaultKaptcha();
        Properties properties = new Properties();
//        图片边框
        properties.put("kaptcha.border", "no");
        properties.put("kaptcha.textproducer.font.color", "black");
//        图片高宽
        properties.put("kaptcha.image.width", "150");
        properties.put("kaptcha.image.height", "40");
//        字体大小
        properties.put("kaptcha.textproducer.font.size", "30");
//        存在session中的key
        properties.put("kaptcha.session.key", "verifyCode");
//        验证码长度
        properties.put("kaptcha.textproducer.char.length", "5");
//        文字间隔
        properties.put("kaptcha.textproducer.char.space", "5");
//        图片样式
        properties.put("kaptcha.obscurificator.impl", "com.google.code.kaptcha.impl.FishEyeGimpy");
        Config config = new Config(properties);
        defaultKaptcha.setConfig(config);

        return defaultKaptcha;
    }
}
```

### controller

```java
@Controller
public class KaptchaController {

    @Autowired
    private DefaultKaptcha captchaProducer;

    @GetMapping("/kaptcha")
    public void defaultKaptcha(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {
        byte[] captchaOutputStream = null;
        ByteArrayOutputStream imgOutputStream = new ByteArrayOutputStream();
        try {
            // 生产验证码字符串并保存到session中
            String verifyCode = captchaProducer.createText();
            System.out.println(verifyCode);
            httpServletRequest.getSession().setAttribute("verifyCode", verifyCode);
            BufferedImage challenge = captchaProducer.createImage(verifyCode);
            ImageIO.write(challenge, "jpg", imgOutputStream);
        } catch (IllegalArgumentException e) {
            httpServletResponse.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        captchaOutputStream = imgOutputStream.toByteArray();
        httpServletResponse.setHeader("Cache-Control", "no-store");
        httpServletResponse.setHeader("Pragma", "no-cache");
        httpServletResponse.setDateHeader("Expires", 0);
        httpServletResponse.setContentType("image/jpeg");
        ServletOutputStream responseOutputStream = httpServletResponse.getOutputStream();
        responseOutputStream.write(captchaOutputStream);
        responseOutputStream.flush();
        responseOutputStream.close();
    }
}

```

