# Swgger2

​	Swagger 是一个根据接口生成API文档,进行测试

​	这里主要是结合springboot方便测试使用

## 依赖

这里只列出springboot版本 以及swagger所需的依赖

```xml
 <parent>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-parent</artifactId>
     <version>2.2.0.RELEASE</version>
     <relativePath/> <!-- lookup parent from repository -->
 </parent>
  <dependencies>
        <dependency>
           <groupId>io.springfox</groupId>
           <artifactId>springfox-swagger2</artifactId>
           <version>2.9.2</version>
       </dependency>

        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger-ui</artifactId>
            <version>2.9.2</version>
        </dependency>
  </dependencies>	
```



## 配置类

主要配置生成的API的title和开启Swagger接口文档

```java
@Configuration //标记配置类
@EnableSwagger2 //开启在线接口文档
public class Swagger2Config {
    /**
     * 添加摘要信息(Docket)
     */
    @Bean
    public Docket controllerApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(new ApiInfoBuilder()
                        .title("接口测试")
                        .description("接口测试")
//                        .contact(new Contact("一只袜子", null, null))
                        .version("版本号:1.0")
                        .build())
                .select()
                .apis(RequestHandlerSelectors.basePackage("xyz.taoqz.controller"))
                .paths(PathSelectors.any())
                .build();
    }
}

```



## 示例代码

```java
@Api(value = "emp")
@RestController
@CrossOrigin
@RequestMapping("/emp")
public class EmpController {

    @Autowired
    private IEmpService iEmpService;

    @ApiOperation(value = "根据id删除",httpMethod = "DELETE")
    @DeleteMapping("/{id}")
    public ResponseEntity<BaseResult> deleteById(@PathVariable Integer id){
        try {
            iEmpService.removeById(id);
            baseResult.setMsg("删除成功");
            baseResult.setStateCode(StateCode.SUCCESS);
        } catch (Exception e) {
            baseResult.setMsg("删除失败");
            baseResult.setStateCode(StateCode.FAIL);
        }
        return ResponseEntity.ok(baseResult);
    }
}
```

生成后的api文档页面

访问接口: http://localhost:8080/swagger-ui.html

使用: 点击其中一个接口 Try it out 填写好参数后 Excute发送请求

![](F:/software/note/img/swagger.jpg)

推荐使用Idea中的插件RestServices,可以更加方便进行测试



## 其他主要注解

<https://blog.csdn.net/xupeng874395012/article/details/68946676>

<https://blog.csdn.net/weixin_41846320/article/details/82970204>