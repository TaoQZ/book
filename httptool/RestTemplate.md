# RestTemplate



## RestTemplate是什么?

​	是一个可以在服务器之间相互调用,发送http请求的工具包,封装了其他有相同功能的工具包,使用更加简洁方便

## 使用

### 所需依赖

```xml
 <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-web</artifactId>
 </dependency>
```

### 解决中文乱码问题

```java
@Configuration
public class RestTemplateConfig {

    //第二种 不用配置类,可以直接在SpringBoot 启动类注册
    @Bean
    public RestTemplate restTemplate() {
        // 默认的RestTemplate，底层是走JDK的URLConnection方式。
        // 设置中文乱码问题方式一
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(1,new StringHttpMessageConverter(Charset.forName("UTF-8")));
        // 设置中文乱码问题方式二
        //        restTemplate.getMessageConverters().set(1,
//                new StringHttpMessageConverter(StandardCharsets.UTF_8)); // 支持中文编码
        return restTemplate;
    }

}
```

### 访问中国天气出现乱码

```java
请求接口: http://wthrcdn.etouch.cn/weather_mini?city=北京
```

增加依赖

```xml
 <dependency>
     <groupId>org.apache.httpcomponents</groupId>
     <artifactId>httpclient</artifactId>
     <version>4.4</version>
 </dependency>
```

修改配置类

```java
//获得的返回数据是经过 GZIP 压缩过的, 而默认的URLConnection无法支持所以考虑创建使用httpClient的RestTemplate

RestTemplate restTemplate = new RestTemplate(
                new HttpComponentsClientHttpRequestFactory()); // 使用HttpClient，支持GZIP
        restTemplate.getMessageConverters().set(1,
                new StringHttpMessageConverter(StandardCharsets.UTF_8)); // 支持中文编码
```



### 简单使用

```java
@RestController
@RequestMapping("/rest")
public class RestTemplateController {

    @Autowired
    private RestTemplate restTemplate;

    private String urlPrefix = "http://localhost:8080/";

    @GetMapping
    public ResponseEntity<BaseResult> findAll(){
        ResponseEntity<BaseResult> forEntity = restTemplate.getForEntity(urlPrefix + "brand", BaseResult.class);
        return forEntity;
    }	
    
       @GetMapping("/product")
    public ResponseEntity<BaseResult> findAllProduct(PageRequest pageRequest){
        // 也可以直接将参数拼接在地址栏上 注意传递参数是 参数为null 会被拼接为字符串的问题
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("pageNum",pageRequest.getPageNum());
        hashMap.put("pageSize",pageRequest.getPageSize());
        ResponseEntity<BaseResult> forEntity = restTemplate.getForEntity(urlPrefix + "product?pageNum={pageNum}&pageSize={pageSize}",BaseResult.class,hashMap);
        return forEntity;
    }

    @PostMapping
    public ResponseEntity<String> add(@RequestBody TbProduct tbProduct){
        ResponseEntity<String> forEntity = restTemplate.postForEntity(urlPrefix + "product",tbProduct, String.class);
        return ResponseEntity.ok(forEntity.getBody());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteById(@PathVariable Integer id){
        restTemplate.delete(urlPrefix + "product/"+id);
        return ResponseEntity.ok("删除成功");
    }

    @PutMapping
    public ResponseEntity<String> edit(@RequestBody TbProduct tbProduct){
        restTemplate.put(urlPrefix + "product",tbProduct);
        return ResponseEntity.ok("修改成功");
    }
}
```

