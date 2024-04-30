# Lambda访问外部变量

## 局部变量

可以访问num变量和进行final修饰后的num变量,那么区别在哪里

可以看到如果变量在lambda表达式后进行修改会报错,也就是num变量必须是final的

在不进行修改的情况下为什么第一个注释掉的num也可用,是因为此时的num是隐式的final,也就是后续没有进行修改

```java
    public static void main(String[] args) {
//        Integer num = 123;
        final Integer num = 123;
        Function<String,Integer> function = (param) -> Integer.parseInt(param)+num;
        Integer apply = function.apply("12");
        System.out.println(apply);
//        Error:(14, 80) java: 从lambda 表达式引用的本地变量必须是最终变量或实际上的最终变量
//        num = 11;
    }
```

在lambda表达式中修改变量也是不可用的

```java
    public static void main(String[] args) {
        Integer num = 123;
        Function<String,Integer> function = (param) -> {
            Integer result =Integer.parseInt(param)+num;
//        Variable used in lambda expression should be final or effectively final
            num = 1;
            return result;
        };
        Integer apply = function.apply("12");
        System.out.println(apply);
    }
```

不允许声明一个与局部变量同名的参数或者局部变量

```java
    public static void main(String[] args) {
        Integer num = 123;
//		Variable 'num' is already defined in the scope
        Function<String,Integer> function = (num) -> Integer.parseInt(num)+num;
        Integer apply = function.apply("12");
        System.out.println(apply);
    }
```

## 成员变量及静态变量

```java
public class MyLambda {

//  非包装类的基本数据类型,静态和非静态都是有默认值的
    static int num;
    int number;

    public void print(){

//        静态变量
         Function<String,Integer> function1 = param -> {
          num = 1;
          return Integer.parseInt(param)+num;
        };
        System.out.println(function1.apply("123"));

//      成员变量
        Function<String,Integer> function2 = param -> {
            number = 2;
            return Integer.parseInt(param)+number;
        };
        System.out.println(function2.apply("456"));
    }

    @Test
    public void fun(){
        new MyLambda().print();
    }

}
```

## 访问接口的默认方法

```java
// method方法和converter 都是将字符串转为Integer,为了演示Lambda是否可以直接调用默认方法
@FunctionalInterface
public interface MyFunction {

    Integer method(String string);

    default Integer converter(String string){
        return Integer.parseInt(string);
    }
}
```

```java
 @Test
    public void fun(){
       MyFunction myFunction = param -> Integer.parseInt(param);
        Integer result1 = myFunction.method("123");
        System.out.println(result1);

//        使用匿名对象的方式可以访问接口中的默认方法
        MyFunction myFunction2 = new MyFunction(){
            @Override
            public Integer method(String string) {
                return converter(string);
            }
        };

        Integer result2 = myFunction2.method("456");
        System.out.println(result2);

        // lambda不能访问接口中的默认方法
//        MyFunction myFunction3 = param -> converter(param);
    }
```

