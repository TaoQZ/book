# 代理模式

我们在学习Spring框架时,了解了其两个最大的优点就是IOC和AOP,其中的AOP用到的就是代理模式(动态代理)。在代理模式中一个类代表另一个类的功能,这种类型的设计模型属于结构型模式。

主要使用场景,当我们需要对对象中的方法进行增强时,为了不侵入原有的代码进行功能扩展,使方法的功能或者说职责更加清晰。

## 静态代理

该方式需要目标对象和代理对象要实现同一类接口,可以实现在不修改原有代码的基础上进行功能的扩展,但是如果有多个需要代理的类的对象或者接口中有大量方法需要实现,这就会需要创建很多的代理类并且进行实现,代码过于冗余。

```java
// 需要被目标类和代理类实现的接口
public interface UserService {
    void update();
}
```

```java
// 目标类
public class UserServiceImpl implements UserService{
    @Override
    public void update() {
        System.out.println("update");
        int i = 1/0;
    }
}
```

```java
// 代理类
public class UserServiceProxy implements UserService{

    // 在代理类的内部维护一个目标类的对象
    private UserService target;

    public UserServiceProxy(UserService target){
        this.target = target;
    }
	
    // 代理类和目标类实现了同一接口,并对方法实现重写
    // 在代理类对象的方法中调用目标类对象的方法,从而对其进行增强
    // 该方法模仿了一个事务的过程
    @Override
    public void update() {
        System.out.println("start transaction");
        try {
            target.update();
        } catch (Exception e) {
            System.out.println("rollback");
            return;
        }
        System.out.println("commit");
    }
}
```

```java
// console
start transaction
update
rollback
```



## JDK代理

jdk动态代理利用了java中的反射(主要涉及的类java.lang.reflect.Proxy),在运行时动态生成交由jvm进行处理,编译完成后不修改配置的话没有实际的class文件。目标类(被代理类)必须需要实现接口。

```java
// 需要被目标类实现的接口
public interface UserService {
    void save();
    void remove();
}
```

```java
// 目标类
public class UserServiceImpl implements UserService{
    @Override
    public void save() {
        System.out.println("save");
        int i = 1/0;
    }

    @Override
    public void remove() {
        System.out.println("remove");
    }
}
```

```java
// 创建一个类实现InvocationHandler接口,主要实现其invoke方法
public class MyProxy implements InvocationHandler {

    private Object target;

    public MyProxy(Object target){
        this.target = target;
    }

    /**
     * @param proxy 方法被调用的代理实例
     * @param method 被代理对象的方法
     * @param args 方法的参数
     * @return 运行结果
     * @throws Throwable
     */
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("start transaction");
        Object result;
        try {
            result = method.invoke(target, args);
        } catch (Exception e) {
            System.out.println("rollback");
            return null;
        }
        System.out.println("commit");
        return result;
    }
}
```



```java
    @Test
    public void demo() throws Throwable {
        UserService target = new UserServiceImpl();
        MyProxy myProxy = new MyProxy(target);
        // 使用Proxy和自实现的InvocationHandler接口,返回代理类对象
        UserService proxyInstance = (UserService) Proxy.newProxyInstance(target.getClass().getClassLoader(), target.getClass().getInterfaces(), myProxy);
        proxyInstance.save();
    }
```



## CGLIB动态代理

cglib采用了非常底层的字节码技术为一个类创建子类,并在子类中对父类方法进行拦截。由于cglib是通过继承来实现代理的所以目标类不能是final的(被final修饰的类不能被继承),并且不会对类中的final方法进行代理(被final修饰的方法不能被重写)

需要导包

```xml
<dependency>
    <groupId>cglib</groupId>
    <artifactId>cglib</artifactId>
    <version>3.2.5</version>
</dependency>
```

```java
// 可以不实现接口
public class UserService {
    public void save(){
        System.out.println("save");
    }
    public void remove(){
        System.out.println("remove");
    }
}
```

```java
// 自定义方法拦截类
public class MyMethodInterceptor implements MethodInterceptor {

    /**
     * @param o 表示要进行增强的对象
     * @param method 表示拦截的方法
     * @param objects 数组表示参数列表，基本数据类型需要传入其包装类型，如int-->Integer、long-Long、double-->Double
     * @param methodProxy 表示对方法的代理，invokeSuper方法表示对被代理对象方法的调用
     * @return 执行结果
     * @throws Throwable
     */
    @Override
    public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
        System.out.println("before");
        // 注意这里是调用 invokeSuper 而不是 invoke，否则死循环，methodProxy.invokesuper执行的是原始类的方法，method.invoke执行的是子类的方法
        Object result = methodProxy.invokeSuper(o, objects);
        System.out.println("after");
        return result;
    }

}
```

```java
public class MyTest {

    public static void main(String[] args) {

        MyMethodInterceptor myMethodInterceptor = new MyMethodInterceptor();
        Enhancer enhancer = new Enhancer();
//        设置超类,即指目标类,cglib是通过继承实现的
        enhancer.setSuperclass(UserService.class);
//        传入自实现的方法拦截类
        enhancer.setCallback(myMethodInterceptor);
//        创建对象
        UserService proxy = (UserService) enhancer.create();
        proxy.save();
    }
}

```

还可以创建多个MethodInterceptor实现类结合CallbackFilter,进行选择性(不同的)增强

```java
public class MyMethodInterceptor2 implements MethodInterceptor {
    @Override
    public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
        System.out.println("我是经过过滤器到达的增强");
        methodProxy.invokeSuper(o,objects);
        return null;
    }
}
```

```java
public class UserServiceFilter implements CallbackFilter {
    @Override
    public int accept(Method method) {
        if (method.getName().equals("remove")){
            // 根据setCallbacks方法中传入的MethodInterceptor的实现类数组的索引
            return 1;
        }
        return 0;
    }
}
```

```java
public class MyTest {

    public static void main(String[] args) {

        MyMethodInterceptor myMethodInterceptor = new MyMethodInterceptor();
        MyMethodInterceptor2 myMethodInterceptor2 = new MyMethodInterceptor2();
        Enhancer enhancer = new Enhancer();
//        设置超类,即指目标类,cglib是通过继承实现的
        enhancer.setSuperclass(UserService.class);
//        传入自实现的方法拦截类
        enhancer.setCallbacks(new Callback[]{myMethodInterceptor,myMethodInterceptor2});
        enhancer.setCallbackFilter(new UserServiceFilter());
//        创建对象
        UserService proxy = (UserService) enhancer.create();
        proxy.save();
        proxy.remove();
    }
}
```



## 总结

静态代理:实现较简单,目标类和代理类需要实现一致的接口(其实就是进行包装一下),有多个目标类需要增强就要创建多个代理类。

jdk动态代理:代理类只需要实现InvocationHandler接口,实现其invoke方法,在其内部对目标类进行调用和增强,目标类必须要实现一个接口。

cglib:解决了jdk动态代理目标类必须实现一个接口的问题,并且cglib更加强大。同时目标类和代理类无需实现接口,但是目标类不能是final的,需要被增强的方法不能是final的。



## 资料

https://juejin.im/post/5c1ca8df6fb9a049b347f55c#heading-8

https://segmentfault.com/a/1190000011291179











