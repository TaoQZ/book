swagger2

版本 : 2.9.2

记录一次错误

```java
java.lang.NumberFormatException: For input string: ""
```

当写dataType时,需要填写example参数

```java
    @ApiImplicitParams({
//        @ApiImplicitParam(value = "10", name = "名称", example = "1000",required = false, paramType = "query", dataType = "int", dataTypeClass = Integer.class)
        @ApiImplicitParam(name = "名称",required = false, paramType = "query",  dataType = "int")
    })
```

