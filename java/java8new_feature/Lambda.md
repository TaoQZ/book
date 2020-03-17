# Lambda表达式

Lambda 允许把函数作为一个方法的参数(将函数作为参数传递到方法中)

可以使代码变得更加简洁紧凑

重要特征

不需要声明参数的类型,编译器可以进行识别

当函数表达式只有一个参数时可以省略小括号(有多个不可省略)

如果函数表达式的实现主体只有一个语句,不需要大括号

如果函数表达式的主体只有一个返回值,编译器会自动返回(省略大括号及return)

对Lambda的个人理解:本质是一个已经实现了方法主体的对象,减少了实现类和简化了匿名内部类的代码

## 函数式接口

在Java8中可以写成函数表达式,是因为Java8提供了函数式接口,只有这些函数式接口才可以简写成Lambda表达式,并且Java编译器可以进行类型推断

函数式接口(Functional Interface)就是一个有且仅有一个抽象方法，但是可以有多个非抽象方法的接口。

函数式接口可以被隐式转换为 lambda 表达式。

### 自定义函数式接口

```java
// 接口中只有并且只有一个抽象方法的接口就是一个函数式接口
@FunctionalInterface // 该注解会检查是否符合函数式接口的规范,符合规则不写也可以
public interface MyFunctionalInterface {
// 默认public abstract
    void method();
//    void fun();
}
```

```java
public class MyTest {
    public static void main(String[] args) {
        fun(() -> System.out.println("123"));
    }

    private static void fun(MyFunctionalInterface myFunctionalInterface){
        myFunctionalInterface.method();
    }
}
```

## 方法引用

方法引用使用一对::冒号,通过方法的名字来指向一个方法

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Bird {

    private int age;

    private String name;

    public static Bird Birdfactory(Supplier<Bird> supplier){
        return supplier.get();
    }

    public static String getBirdName(Supplier<String> supplier){
        return supplier.get();
    }

    public void print(){
        System.out.println(name);
    }

    public String getName() {
//        System.out.println(name);
        return name;
    }

    public static void print2(Bird bird){
        System.out.println("静态方法");
    }

}
```

```java
public class MyTest3 {

    public static void main(String[] args) {

//      构造器引用  ClassName::new
        Bird bird = Bird.Birdfactory(Bird::new);
        bird.setName("啄木鸟");
        bird.setAge(2);
//      使用的是Supplier接口 
        Supplier<Bird> supplier = Bird::new;
        Bird bird1 = supplier.get();

        
//      特定对象的方法引用 Supplier  instance::method
        String birdName = Bird.getBirdName(bird::getName);
        System.out.println(birdName);

//		 为了演示其他对象也可以使用该方式进行方法的引用        
//        String str = "qwe";
//        String birdName1 = Bird.getBirdName(str::toUpperCase);
//        System.out.println(birdName1);

        System.out.println("=================");
        
        List<Bird> birds = Arrays.asList(bird,
                new Bird(5,"八声杜鹃"),
                new Bird(6,"雎鸠"),
                new Bird(3,"沙百灵")
                );
        
//        下面两者本质是一个消费者 Consumer 在forEach中会调用其accept()方法
//        特定类的任意对象的方法的引用 Class:new
        birds.forEach(Bird::print);
        System.out.println("=============");
        
//        静态方法引用 Class::static_method
//        birds.forEach(Bird::print2);
		 Function<Double,Double> fun =  Math::ceil;
          Double apply = fun.apply(100.1);
          System.out.println(apply);
        
//        在这里的时候遇到了一个问题(理解不到位),使用forEach(Bird::getName)为什么不可以,因为forEach的参数是个Consumer消费者
//        只会调用方法不会对其返回值有操作
//        流操作对最终的集合没有影响
        birds.stream().sorted(Comparator.comparing(Bird::getAge)).forEach(System.out::println);
        /* Bird(age=2, name=啄木鸟)
 	   Bird(age=3, name=沙百灵)
 	   Bird(age=5, name=八声杜鹃)
  	   Bird(age=6, name=雎鸠)*/

//        List<Bird> collect = birds.stream().sorted(Comparator.comparing(Bird::getName)).collect(Collectors.toList());
//        System.out.println(collect);

        System.out.println(birds);
// [Bird(age=2, name=啄木鸟), Bird(age=5, name=八声杜鹃), Bird(age=6, name=雎鸠), Bird(age=3, name=沙百灵)]        
    }

}
```

### 创建数组

```java
//        指定长度 分配空间并初始默认值(不同的类型有不同的默认值)
        int[] one = new int[10];
//        显示初始化
        int[] two = {1,2,3};
//        显示初始化
        int[] three = new int[]{1,2,3};
//        数组一旦进行初始化,分配内存空间,其数组长度不可变

//        使用方法引用的方式创建数组
//        因为需要指定数组的长度,java使用了Function接口 利用了其方法的特点 传入第一个泛型类型的参数,返回值一个第二个泛型类型的值
        Function<Integer, String[]> functionStringArray = String[]::new;
        String[] apply = functionStringArray.apply(10);
        System.out.println(apply.length);
        System.out.println(apply[0]);
```



## 内置的函数式接口

JDK在java.util.function包中提供了大量常用的函数式接口

创建一个bean方便后面使用

```java
@Data
@AllArgsConstructor
public class Person {
    private String name;
    private Integer age;
}
```



### Supplier<T>

该接口仅包含一个无参的方法,返回值和泛型一致

```java
public class SupplierDemo {

    // 生产一个数据 返回值便为泛型
    private static String getString(Supplier<String> funtion){
        return funtion.get();
    }

    @Test
    public void fun(){
        String name = "java";
        String string = getString(name::toUpperCase);
        System.out.println(string);
    }
}
```

### Consumer<T>

接收一个参数无返回值,类似消费者

```java
public class ConsumerDemo {

    // 消费一个数据
    private static void printString(Consumer<Person> function,Person person){
        function.accept(person);
    }

    // 将数据按照函数表达式的顺序完成操作
    private static void consumerString(Consumer<String> one,Consumer<String> two,String zz){
        one.andThen(two).accept(zz);
    }

    public static void main(String[] args) {
        Person person = new Person("张三", 123);
        printString(s -> System.out.println(s.getName()),person);
        consumerString(
                s -> System.out.println(s.toLowerCase()+"==one"),
                s -> System.out.println(s.toUpperCase()+"==two"),"cZxy"
        );
    }
}
```

### Predicate<T>

接收一个参数,返回一个布尔值结果

```java
public class PredicateDemo {

//    提供返回值为布尔类型的函数式接口
//    test 判断
//    negate 取反
    private static boolean stringLength(Predicate<String> funtion,String string){
        return funtion.test(string);
//        return funtion.negate().test(string);
    }

    // 完成多个数据之间的逻辑判断 or或者 and并且
    private static boolean stringContains(Predicate<String> one,Predicate<String> two,String string){
//        or方法的参数也是一个函数表达式
        return one.or(two).test(string);
//        return one.and(two).test(string);
    }

    public static void main(String[] args) {
//        参数长度是否大于50
        System.out.println(stringLength(s -> s.length() > 50,"Hello World"));
        
//        参数是否以J开头或者包含W
        System.out.println(stringContains(one -> one.startsWith("J"),
                                            two -> two.contains("W"),"Hello World "));
        
//        将字符串切割后 sex为女 名字长度为4的返回做输出打印
        String[] array = { "迪丽热巴,女","古力娜扎,女","马尔扎哈,男","赵丽颖,女"};
        demo( sex -> sex.split(",")[1].equals("女"),
                length -> length.split(",")[0].length() == 4,array).forEach(System.out::println);
    }


    private static List<String> demo(Predicate<String> sex,Predicate<String> length,String[] string){
        ArrayList<String> strings = new ArrayList<>();
        for (String s : string) {
            if (sex.and(length).test(s)){
                strings.add(s);
            }
        }
        return strings;

    }
}
```

### Function<T,R>

接收一个参数T,返回一个结果R

```java
public class FunctionDemo {

//    apply参数是第一个泛型的类型,返回值是第二个参数的泛型的类型
//    当然两个泛型可以一样
    private static void method(Function<String,Integer> funtion,String num){
        System.out.println(funtion.apply(num)+1);
    }

    public static void main(String[] args) {
        method(Integer::parseInt,"50");

        String person = "赵丽颖,20";
        example(
                age -> age.split(",")[1],
                Integer::parseInt,
                add -> add += 100,
                person
        );
    }

//      需求,拿到字符串中的数字转为Integer再进行数学运算
//		第一个参数 拿到字符串中的数字字符串
//      再将数字字符串转为Integer
//      对数字进行数学运算
//		其中参数的泛型: 从第二个参数开始,第一个泛型的类型都是前一个参数的返回值类型    
//      andThen 和consumer中的作用类似,都是先执行什么操作然后在根据结果执行另一个操作
    private static void example(Function<String,String> split,Function<String,Integer> parseInt,Function<Integer,Integer> result,String age){
        System.out.println(split.andThen(parseInt).andThen(result).apply(age));
    }
}
```

### Comparator比较器

```java
public class ComparatorDemo {

    // java8之后改为函数表达式
    // 返回值是一个函数表达式
    private static Comparator<String> myComparator(){
        return (a, b) -> b.length() - a.length() ;
    }

    public static void main(String[] args) {
        String[] array = {"asd","qwer","zz"};

        // java8之前的写法
        // o1代表当前元素 o2代表其后的元素 返回值为1 o1向右放 -1 o1向左放 0相等 不动
//       Arrays.sort(array, new Comparator<String>() {
//           @Override
//           public int compare(String o1, String o2) {
//               return o2.length() - o1.length();
//           }
//       });

        Arrays.sort(array,myComparator());
        System.out.println(Arrays.toString(array));
    }
}
```



