# Zuul

## 什么是Zuul

Zuul是从设备和网站到Netflix流应用程序后端的所有请求的前门。作为边缘服务应用程序，Zuul旨在实现动态路由，监视，弹性和安全性。它还可以根据需要将请求路由到多个Amazon Auto Scaling组。

## 为什么使用

Netflix API流量的数量和多样性有时会导致生产问题迅速出现而没有警告。我们需要一个允许我们快速改变行为以对这些情况做出反应的系统。

Zuul使用了各种不同类型的过滤器，这使我们能够快速灵活地将功能应用于边缘服务。这些过滤器帮助我们执行以下功能：

- 身份验证和安全性-识别每个资源的身份验证要求，并拒绝不满足要求的请求。
- 见解和监控-在边缘跟踪有意义的数据和统计信息，以便为我们提供准确的生产视图。
- 动态路由-根据需要将请求动态路由到不同的后端群集。
- 压力测试-逐渐增加到群集的流量以评估性能。
- 减载-为每种类型的请求分配容量，并丢弃超出限制的请求。
- 静态响应处理-直接在边缘构建一些响应，而不是将其转发到内部集群
- 多区域弹性-在AWS区域之间路由请求，以多样化我们的ELB使用并将我们的优势拉近我们的成员

## 依赖

```xml
 <dependencies>
  <dependency>
     <groupId>org.springframework.cloud</groupId>
     <artifactId>spring-cloud-starter-netflix-zuul</artifactId>
  </dependency>
     <!-- 通常结合eureka使用 -->
     <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
      </dependency>
 </dependencies> 
  
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
```

## 注解

```java
@EnableZuulProxy // 开启网关功能
@EnableEurekaClient // 开启eureka客户端服务
```

## 配置

```yml
# 将服务注册到Eureka,并且拉取其他服务
eureka:
  client:
    registry-fetch-interval-seconds: 5 # 获取服务列表的周期：5s
    service-url:
      defaultZone: http://127.0.0.1:8083/eureka
    fetch-registry: true # 是否拉取其他服务,默认true
  instance:
    prefer-ip-address: true
    ip-address: 127.0.0.1
```

### 路径映射规则

#### 指定url访问

```yml
zuul:
  routes:
    user-service: # 这里是路由id，随意写
      path: /user-service/** # 这里是映射路径	
      # 访问/user-service/**时会请求 http://127.0.0.1:8081/   
      url: http://127.0.0.1:8081 # 映射路径对应的实际url地址
```

#### 指定服务名

```yaml
zuul:
  routes:
    user-service: # 这里是路由id，随意写
      path: /user-service/** # 这里是映射路径	
      # 使用Eureka,通过服务名访问,并且会利用Ribbon的负载均衡
	  service-id: user-service # 指定服务名称
```

#### 简化

路由名称往往和服务名一样,因此可以简化成如下,或者直接选择不配置,也会默认根据此规则发送请求,路由名称对应服务名称

```yaml
zuul:
  prefix: /api # 添加路由前缀,可选项
  routes:
    user-service: /user-service/** # 这里是映射路径
```

### 过滤器

​	和之前在servlet时学的过滤器功能类似

​	自定义过滤器

​	自定义需要实现类ZuulFilter,以下是其最重要的四个方法

```java
public abstract class ZuulFilter implements IZuulFilter{

    abstract public String filterType();

    abstract public int filterOrder();
    
    boolean shouldFilter();// 来自IZuulFilter

    Object run() throws ZuulException;// IZuulFilter
}
```

- shouldFilter`：返回一个`Boolean`值，判断该过滤器是否需要执行。返回true执行，返回false不执行。
- `run`：过滤器的具体业务逻辑。
- `filterType`：返回字符串，代表过滤器的类型。包含以下4种：
  - `pre`：请求在被路由之前执行
  - `routing`：在路由请求时调用
  - `post`：在routing和errror过滤器之后调用
  - `error`：处理请求时发生错误调用
- `filterOrder`：通过返回的int值来定义过滤器的执行顺序，数字越小优先级越高。

示例

```java
import com.netflix.zuul.ZuulFilter;
import com.netflix.zuul.context.RequestContext;
import com.netflix.zuul.exception.ZuulException;
import io.jsonwebtoken.Claims;
import org.springframework.stereotype.Component;
import xyz.taoqz.utils.JWTUtil;

import javax.servlet.http.HttpServletRequest;

/**
 * 鉴权
 */
@Component
public class JWTFilter extends ZuulFilter {
    @Override
    public String filterType() {
        return "pre";
    }

    @Override
    public int filterOrder() {
        return 1;
    }

    @Override
    public boolean shouldFilter() {
        return true;
    }

    /**
     * 编写权限过滤的核心业务：
     * 主要任务：确认是否放行
     * 根据URL确认是否放行
     * 有些URL是需要登陆之后才能访问，有些URL不需要登陆就可以访问
     * 如果需要登陆的URL，需要获取token，并且解析token，成功了，就放行，不成功，就拦截
     */
    @Override
    public Object run() throws ZuulException {

        RequestContext ctx = RequestContext.getCurrentContext();
        HttpServletRequest request = ctx.getRequest();

        if (request.getRequestURI().contains("/login")){
            return null;
        }

        String token = request.getHeader("authorization");
		
        // 结合了JWT使用
        if (token != null && !("").equals(token.trim())){
            Claims example0102 = JWTUtil.parseToken(token.trim(), "example0102");
            if (example0102 != null){
                ctx.addZuulRequestHeader("authorization",token);
                return null;
            }
        }

        // 拦截
        ctx.setSendZuulResponse(false);
        ctx.setResponseStatusCode(401);
        ctx.setResponseBody("{'msg':'校验失败'}");
        ctx.getResponse().setContentType("text/html;charset=utf-8");//  不设置的话，中文乱码

        return null;
    }
}
```



### fallback

将所有服务收缩到到网关之后,需要通过网关请求服务,如果服务未启动或者请求超时,希望返回自定义信息而不是返回错误信息。

```java
@Component
public class ZuulFallback implements FallbackProvider {

    // 表明是为哪个微服务提供回退，*表示为所有微服务提供回退
    @Override
    public String getRoute() {
        return "*";
    }

    @Override
    public ClientHttpResponse fallbackResponse(String route, Throwable cause) {
        System.out.println("路由名称"+route);
        System.out.println(cause.getMessage());
//        返回客户端的响应状态码
//        return this.response(HttpStatus.OK);
        return this.response(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    private ClientHttpResponse response(final HttpStatus status) {
        return new ClientHttpResponse() {

            @Override
            public HttpStatus getStatusCode() throws IOException {
                return status;
            }

            @Override
            public int getRawStatusCode() throws IOException {
                return status.value();
            }

            @Override
            public String getStatusText() throws IOException {
                return status.getReasonPhrase();
            }

            @Override
            public void close() {
            }

            @Override
            public InputStream getBody() throws IOException {
                RequestContext currentContext = RequestContext.getCurrentContext();
                int status = currentContext.getResponse().getStatus();
                System.out.println(status);
//                 响应给客户端的信息
                String json = "{\"msg\": \"服务不可用，请稍后再试。\"}";
                return new ByteArrayInputStream(json.getBytes());
            }

            @Override
            public HttpHeaders getHeaders() {
                // headers设定
                HttpHeaders headers = new HttpHeaders();
                MediaType mt = new MediaType("application", "json", Charset.forName("UTF-8"));
                headers.setContentType(mt);
                return headers;
            }

        };
    }

}

```



### 跨域

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;


/**  全局跨域配置类
 */
@Configuration
public class GlobalCorsConfig {
    @Bean
    public CorsFilter corsFilter() {
        //1.添加CORS配置信息
        CorsConfiguration config = new CorsConfiguration();
        //放行哪些原始域
        config.addAllowedOrigin("*");
        //是否发送Cookie信息
        config.setAllowCredentials(true);
        //放行哪些原始域(请求方式)
        config.addAllowedMethod("OPTIONS");
        config.addAllowedMethod("HEAD");
        config.addAllowedMethod("GET");     //get
        config.addAllowedMethod("PUT");     //put
        config.addAllowedMethod("POST");    //post
        config.addAllowedMethod("DELETE");  //delete
        config.addAllowedMethod("PATCH");
        config.addAllowedHeader("*");

        //2.添加映射路径
        UrlBasedCorsConfigurationSource configSource = new UrlBasedCorsConfigurationSource();
        configSource.registerCorsConfiguration("/**", config);

        //3.返回新的CorsFilter.
        return new CorsFilter(configSource);
    }

}
```

```yml
zuul:
  sensitive-headers: Access-Control-Allow-Origin
  ignored-headers: Access-Control-Allow-Origin,H-APP-Id,Token,APPToken
```

### 其他

​	解決请求头丢失问题,zuul会默认过滤掉部分请求头

```yaml
zuul:
  sensitive-headers:
```

