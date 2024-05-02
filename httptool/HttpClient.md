# HttpClient 



##  什么是HttpClient

HttpClient 是Apache Jakarta Common 下的子项目，可以用来提供高效的、最新的、功能丰富的支持 HTTP 协议的客户端编程工具包，并且它支持 HTTP 协议最新的版本和建议。


特点：

1. HttpClient别名：HttpComponents

2. HttpClient可以发送get、post、put、delete、...等请求

    

## 入门案例

导入maven坐标

```xml
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpclient</artifactId>
    <version>4.4</version>
</dependency>
```

### 发起Get请求

1创建一个客户端 CloseableHttpClient

2创建一个get方法请求实例 HttpGet

3发送请求 execute

4获取响应的头信息 

5获取响应的主题内容

6关闭响应对象

使用HttpClient发起Get请求的案例代码：

```java
public class DoGET {

    public static void main(String[] args) throws Exception {
        // 创建Httpclient对象,相当于打开了浏览器
        CloseableHttpClient httpclient = HttpClients.createDefault();

        // 创建HttpGet请求，相当于在浏览器输入地址
        HttpGet httpGet = new HttpGet("http://www.baidu.com/");

        CloseableHttpResponse response = null;
        try {
            // 执行请求，相当于敲完地址后按下回车。获取响应
            response = httpclient.execute(httpGet);
            // 判断返回状态是否为200
            if (response.getStatusLine().getStatusCode() == 200) {
                // 解析响应，获取数据
                String content = EntityUtils.toString(response.getEntity(), "UTF-8");
                System.out.println(content);
            }
        } finally {
            if (response != null) {
                // 关闭资源
                response.close();
            }
            // 关闭浏览器
            httpclient.close();
        }

    }
}
```

### 带参数的Get请求

1创建一个客户端 CloseableHttpClient

2 通过URIBuilder传递参数

3创建一个get方法请求实例 HttpGet

4发送请求 execute

5获取响应的头信息 

6获取响应的主题内容

7关闭响应对象

访问网站的爬虫协议：

 ```java
public class DoGETParam {

    public static void main(String[] args) throws Exception {
        // 创建Httpclient对象
        CloseableHttpClient httpclient = HttpClients.createDefault();
        // 创建URI对象，并且设置请求参数
        URI uri = new URIBuilder("http://www.baidu.com/s").setParameter("wd", "java").build();
        
        // 创建http GET请求
        HttpGet httpGet = new HttpGet(uri);

        // HttpGet get = new HttpGet("http://www.baidu.com/s?wd=java");
        
        CloseableHttpResponse response = null;
        try {
            // 执行请求
            response = httpclient.execute(httpGet);
            // 判断返回状态是否为200
            if (response.getStatusLine().getStatusCode() == 200) {
                // 解析响应数据
                String content = EntityUtils.toString(response.getEntity(), "UTF-8");
                System.out.println(content);
            }
        } finally {
            if (response != null) {
                response.close();
            }
            httpclient.close();
        }
    }
}
 ```

###  **发起POST请求**

 ```java
/*
 * 演示：使用HttpClient发起POST请求
 */
public class DoPOST {
    public static void main(String[] args) throws Exception {
        // 创建Httpclient对象
        CloseableHttpClient httpclient = HttpClients.createDefault();
        // 创建http POST请求
        HttpPost httpPost = new HttpPost("http://www.oschina.net/");
        // 把自己伪装成浏览器。否则开源中国会拦截访问
        httpPost.setHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36");

        CloseableHttpResponse response = null;
        try {
            // 执行请求
            response = httpclient.execute(httpPost);
            // 判断返回状态是否为200
            if (response.getStatusLine().getStatusCode() == 200) {
                // 解析响应数据
                String content = EntityUtils.toString(response.getEntity(), "UTF-8");
                System.out.println(content);
            }
        } finally {
            if (response != null) {
                response.close();
            }
            // 关闭浏览器
            httpclient.close();
        }

    }
}
 ```



### 带参数POST请求



 ```java
/*
 * 演示：使用HttpClient发起带有参数的POST请求
 */
public class DoPOSTParam {

    public static void main(String[] args) throws Exception {
        // 创建Httpclient对象
        CloseableHttpClient httpclient = HttpClients.createDefault();
        // 创建http POST请求，访问开源中国
        HttpPost httpPost = new HttpPost("http://www.oschina.net/search");

        // 根据开源中国的请求需要，设置post请求参数
        List<NameValuePair> parameters = new ArrayList<NameValuePair>(0);
        parameters.add(new BasicNameValuePair("scope", "project"));
        parameters.add(new BasicNameValuePair("q", "java"));
        parameters.add(new BasicNameValuePair("fromerr", "8bDnUWwC"));
        // 构造一个form表单式的实体
        UrlEncodedFormEntity formEntity = new UrlEncodedFormEntity(parameters);
        // 将请求实体设置到httpPost对象中
        httpPost.setEntity(formEntity);

        CloseableHttpResponse response = null;
        try {
            // 执行请求
            response = httpclient.execute(httpPost);
            // 判断返回状态是否为200
            if (response.getStatusLine().getStatusCode() == 200) {
                // 解析响应体
                String content = EntityUtils.toString(response.getEntity(), "UTF-8");
                System.out.println(content);
            }
        } finally {
            if (response != null) {
                response.close();
            }
            // 关闭浏览器
            httpclient.close();
        }
    }
}
 ```



# SpringBoot整合HttpClient

 

SpringBoot官方并没有对HttpClient的启动器。所以我们需要自己完成配置，还好，我们刚才在测试案例中已经写过了。

 

不过，SpringBoot虽然没有提供启动器，但是却提供了一个统一的对Restful服务进行调用的模板类：RestTemplate，底层可以使用HttpClient来实现。有了这个我们就无需自己定义APIService了。

1、导入maven坐标

```xml
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpclient</artifactId>
</dependency>
```

 

2、在application.properties添加如下配置:

```properties
#The config for HttpClient 
http.maxTotal=300
http.defaultMaxPerRoute=50
http.connectTimeout=1000
http.connectionRequestTimeout=500
http.socketTimeout=5000
http.staleConnectionCheckEnabled=true
```



3、 创建HttpClientConfig类--类似util

在类中编写代码

```java
/**
 * HttpClient的配置类
 *
 */
@Configuration
@ConfigurationProperties(prefix = "http", ignoreUnknownFields = true)
public class HttpClientConfig {

    private Integer maxTotal;// 最大连接

    private Integer defaultMaxPerRoute;// 每个host的最大连接

    private Integer connectTimeout;// 连接超时时间

    private Integer connectionRequestTimeout;// 请求超时时间

    private Integer socketTimeout;// 响应超时时间

    /**
     * HttpClient连接池
     * @return
     */
    @Bean
    public HttpClientConnectionManager httpClientConnectionManager() {
        PoolingHttpClientConnectionManager connectionManager = new PoolingHttpClientConnectionManager();
        connectionManager.setMaxTotal(maxTotal);
        connectionManager.setDefaultMaxPerRoute(defaultMaxPerRoute);
        return connectionManager;
    }

    /**
     * 注册RequestConfig
     * @return
     */
    @Bean
    public RequestConfig requestConfig() {
        return RequestConfig.custom().setConnectTimeout(connectTimeout)
            .setConnectionRequestTimeout(connectionRequestTimeout).setSocketTimeout(socketTimeout)
            .build();
    }

    /**
     * 注册HttpClient
     * @param manager
     * @param config
     * @return
     */
    @Bean
    public HttpClient httpClient(HttpClientConnectionManager manager, RequestConfig config) {
        return HttpClientBuilder.create().setConnectionManager(manager).setDefaultRequestConfig(config)
            .build();
    }
   /**
     * 使用连接池管理连接
     * @param httpClient
     * @return
     */
    @Bean
    public ClientHttpRequestFactory requestFactory(HttpClient httpClient) {
        return new HttpComponentsClientHttpRequestFactory(httpClient);
    }
    /**
     * 使用HttpClient来初始化一个RestTemplate
     * @param requestFactory
     * @return
     */
    @Bean
    public RestTemplate restTemplate(ClientHttpRequestFactory requestFactory) {
        RestTemplate template = new RestTemplate(requestFactory);

        List<HttpMessageConverter<?>> list = template.getMessageConverters();
        for (HttpMessageConverter<?> mc : list) {
            if (mc instanceof StringHttpMessageConverter) {
                ((StringHttpMessageConverter) mc).setDefaultCharset(Charset.forName("UTF-8"));
            }
        }
        return template;
    }

    public Integer getMaxTotal() {
        return maxTotal;
    }

    public void setMaxTotal(Integer maxTotal) {
        this.maxTotal = maxTotal;
    }

    public Integer getDefaultMaxPerRoute() {
        return defaultMaxPerRoute;
    }

    public void setDefaultMaxPerRoute(Integer defaultMaxPerRoute) {
        this.defaultMaxPerRoute = defaultMaxPerRoute;
    }

    public Integer getConnectTimeout() {
        return connectTimeout;
    }

    public void setConnectTimeout(Integer connectTimeout) {
        this.connectTimeout = connectTimeout;
    }

    public Integer getConnectionRequestTimeout() {
        return connectionRequestTimeout;
    }

    public void setConnectionRequestTimeout(Integer connectionRequestTimeout) {
        this.connectionRequestTimeout = connectionRequestTimeout;
    }

    public Integer getSocketTimeout() {
        return socketTimeout;
    }

    public void setSocketTimeout(Integer socketTimeout) {
        this.socketTimeout = socketTimeout;
    }
}
```