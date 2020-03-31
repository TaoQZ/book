# 单例模式

单例设计模式:属于创建型模式,提供了一种创建对象的最佳方式。这种模式涉及到一个单一的类,该类负责创建自己的对象,同时确保只有单个对象被创建。主要解决一个全局使用的类进行频繁的创建于销毁,耗费大量内存的问题。

注意事项:单例类只能有一个实例,单例类必须自己创建自己的实例并可以提供给其他对象使用

## 饿汉式

这种方式的优点是其为线程安全的,没有加锁,执行效率稍高一些

缺点则是类加载时就初始化,浪费内存(比如有很多类使用的是单例模式,程序在启动时就会创建这些对象,而不管你是否用到了这些类,从而导致程序启动较慢)

```java
public class Singleton1 {
    
//    将构造函数私有化,让外部无法轻易的创建其对象(new的方式)
    private Singleton1(){}
    
//    static修饰的变量属于类,随着类的加载而加载,只加载一次
    private static Singleton1 instance = new Singleton1();
    
//    提供一个公开的访问接口,可以提供给其他对象使用
//    由于构造函数是私有化的,所以只能使用static关键字,可以被类直接调用
    public static Singleton1 getInstance(){
        return instance;
    }
    
}
```

## 懒汉式

懒汉式则是为了解决饿汉式,较为浪费内存的情况,只有在需要的时候才会创建对象,但懒汉式也有其缺点,可能会出现线程安全问题

### 线程不安全

```java
public class Singleton2 {
    
//    单例模式私有构造函数是必须的
    private Singleton2(){}
    
//    同样提供一个类变量
    private static Singleton2 instance;
    
//    提供一个公开的访问方法,但其是会出现线程安全问题的
    public static Singleton2 getInstance(){
//        假如有两条线程t1和t2,此时t1抢到了执行权,进行判断并且判断实例为null,准备创建对象赋值时,被t2抢断
//        t2拿到执行权后顺利的创建完对象,此时t1又抢到了执行权,也去做创建对象并赋值的操作,便出现了创建出不同实例的情况
        if (instance == null){
            instance = new Singleton2();
        }
        return instance;
    }
    
}
```



### 线程安全

为了解决上面的问题,想到了使用synchronized关键字,将其改造为同步方法

```java
public class Singleton3 {

    private Singleton3(){}

    private static Singleton3 instance;

//    我们在方法上添加synchronized关键字,使其变为静态同步方法
//    synchronized需要一个锁对象,在静态方法上的锁对象是类对象(在非静态方法上的锁对象是this,谁调用这个方法this就指向谁),一个类的类对象也只有一个,符合做锁对象的要求
//    为什么可以确定是类对象,还是因为static关键字,static修饰的方法和变量初始化在创建对象之前,此时还没有this
    public static synchronized Singleton3 getInstance(){
        if (instance == null){
            instance = new Singleton3();
        }
        return instance;
    }

}
```



### 双重校验锁

上面加了同步方法的懒汉式虽然是线程安全的,但是其执行效率会变慢,因为每次调用该方法都会等待上一个线程的锁,为了解决这个问题,我们可以使用同步代码块

```java
public class Singleton4 {

    private Singleton4(){}

    private volatile static Singleton4 instance;

    public static Singleton4 getInstance(){

//        在第一个懒汉式中得知,在此处可能会出现线程安全问题,所以我们把同步代码块加在这里
//        锁对象也就是当前的类对象,这样虽然是线程安全的,并且比上一个线程安全的懒汉式看起来执行效率会更高
//        但是每一条线程进来都会等待锁进行判断实例的存在,可以再做优化
        synchronized (Singleton4.class){
            if (instance == null){
                instance = new Singleton4();
            }
        }
        return instance;
    }

}
```

```java
public class Singleton4 {

    private Singleton4(){}

    private static Singleton4 instance;

    public static Singleton4 getInstance(){

//        可以再同步代码块外面再加一层校验,这样其他线程不必等待锁进行判断,也保证了创建对象的安全性
        if (instance == null){
            synchronized (Singleton4.class){
                if (instance == null){
                    instance = new Singleton4();
                }
            }
        }
        return instance;
    }

}
```



