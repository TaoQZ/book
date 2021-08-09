# Spring循环依赖

## Spring创建bean过程

主bean：依赖链中最先被spring加载的bean。

属性注入、setter注入如何解决循环依赖。

使用了三级缓存，会先从一级缓存找然后二级，三级。

- `singletonObjects`：完成初始化的单例对象的 cache，这里的 bean 经历过 `实例化->属性填充->初始化` 以及各种后置处理（一级缓存）
- `earlySingletonObjects`：存放原始的 bean 对象（完成实例化但是尚未填充属性和初始化），仅仅能作为指针提前曝光，被其他 bean 所引用，用于解决循环依赖的 （二级缓存）
- `singletonFactories`：在 bean 实例化完之后，属性填充以及初始化之前，如果允许提前曝光，Spring 会将实例化后的 bean 提前曝光，也就是把该 bean 转换成 `beanFactory` 并加入到 `singletonFactories`（三级缓存）

Spring 为了解决单例的循环依赖问题，使用了三级缓存。其中一级缓存为单例池（`singletonObjects`），二级缓存为提前曝光对象（`earlySingletonObjects`），三级缓存为提前曝光对象工厂（`singletonFactories`）。

## 个人理解

一级缓存：完成初始化的单例对象的 cache，这里的 bean 经历过 `实例化->属性填充->初始化` 以及各种后置处理。

二级缓存：和三级缓存配合解决循环依赖问题，是只存储进行实例化后提前曝光的对象。

三级缓存：是一个bean的对象工厂，创建bean实例化时会将刚实例化后的对象转成对应的bean对象工厂添加到三级缓存中，获取bean时经过三级缓存，三级缓存获取到后，会判断是否需要代理对象，如果需要代理对象三级缓存会创建代理对象，并提供原始对象给代理对象，如果不需要直接返回原始对象，最后会将对象移动至二级缓存，从三级缓存中移除。

## 为什么要三级缓存？

当然如果只解决循环依赖二级缓存确实够用了，但是如果此时需要获取代理对象怎么办，只能在之前将bean统统完成AOP代理，没有必要也不太合适。

构造注入无法解决循环依赖的问题是因为其原理。

比如A依赖B，B依赖A，A使用构造参数注入B。

反射获取调用有参构造，此时必须传入一个B的对象，但是B对象同时依赖了A对象，A对象由于连实例化都没有完成无法获取，需要创建，此时便陷入了循环。

如果主bean也就是A使用setter注入，B使用构造注入，那么循环依赖也可以解决，因为A可以通过反射使用无参构造进行实例化，并将未进行初始化（属性注入）的A添加到对象缓存中，B在使用有参构造是便可以获取到依赖A的引用。



## 获取bean经过三级缓存过程源码

```
DefaultSingletonBeanRegistry.java
```

```java
/** Cache of singleton objects: bean name --> bean instance */
private final Map singletonObjects = new ConcurrentHashMap<>(256);

/** Cache of singleton factories: bean name --> ObjectFactory */
private final Map> singletonFactories = new HashMap<>(16);

/** Cache of early singleton objects: bean name --> bean instance */
private final Map earlySingletonObjects = new HashMap<>(16);

protected Object getSingleton(String beanName, boolean allowEarlyReference) {
    // 从 singletonObjects 获取实例，singletonObjects 中的实例都是准备好的 bean 实例，可以直接使用
    Object singletonObject = this.singletonObjects.get(beanName);
    //isSingletonCurrentlyInCreation() 判断当前单例bean是否正在创建中
    if (singletonObject == null && isSingletonCurrentlyInCreation(beanName)) {
        synchronized (this.singletonObjects) {
            // 一级缓存没有，就去二级缓存找
            singletonObject = this.earlySingletonObjects.get(beanName);
            if (singletonObject == null && allowEarlyReference) {
                // 二级缓存也没有，就去三级缓存找
                ObjectFactory singletonFactory = this.singletonFactories.get(beanName);
                if (singletonFactory != null) {
                    // 三级缓存有的话，就把他移动到二级缓存,.getObject() 后续会讲到
                    singletonObject = singletonFactory.getObject();
                    this.earlySingletonObjects.put(beanName, singletonObject);
                    this.singletonFactories.remove(beanName);
                }
            }
        }
    }
    return singletonObject;
}
```



```
AbstractAutowireCapableBeanFactory
```

```java
doCreateBean()

    // Eagerly cache singletons to be able to resolve circular references
    // even when triggered by lifecycle interfaces like BeanFactoryAware.
    boolean earlySingletonExposure = (mbd.isSingleton() && this.allowCircularReferences &&
                                      isSingletonCurrentlyInCreation(beanName));
if (earlySingletonExposure) {
    if (logger.isTraceEnabled()) {
        logger.trace("Eagerly caching bean '" + beanName +
                     "' to allow for resolving potential circular references");
    }
    // 将实例化后的bean对应的ObjectFactory对象添加到三级缓存中
    addSingletonFactory(beanName, () -> getEarlyBeanReference(beanName, mbd, bean));
}

// Initialize the bean instance.
Object exposedObject = bean;
try {
    populateBean(beanName, mbd, instanceWrapper);
    exposedObject = initializeBean(beanName, exposedObject, mbd);
}
```

```java
protected void addSingletonFactory(String beanName, ObjectFactory<?> singletonFactory) {
    Assert.notNull(singletonFactory, "Singleton factory must not be null");
    synchronized (this.singletonObjects) {
        if (!this.singletonObjects.containsKey(beanName)) {
            this.singletonFactories.put(beanName, singletonFactory);
            this.earlySingletonObjects.remove(beanName);
            this.registeredSingletons.add(beanName);
        }
    }
}

protected Object getEarlyBeanReference(String beanName, RootBeanDefinition mbd, Object bean) {
    Object exposedObject = bean;
    if (!mbd.isSynthetic() && hasInstantiationAwareBeanPostProcessors()) {
        for (BeanPostProcessor bp : getBeanPostProcessors()) {
            // 判断是否有后置方法，如果有后置方法创建代理对象，否则直接返回原对象
            if (bp instanceof SmartInstantiationAwareBeanPostProcessor) {
                SmartInstantiationAwareBeanPostProcessor ibp = (SmartInstantiationAwareBeanPostProcessor) bp;
                exposedObject = ibp.getEarlyBeanReference(exposedObject, beanName);
            }
        }
    }
    return exposedObject;
}
```



```
AbstractAutoProxyCreator.java
```

```java
public Object getEarlyBeanReference(Object bean, String beanName) {
    Object cacheKey = this.getCacheKey(bean.getClass(), beanName);
    this.earlyProxyReferences.put(cacheKey, bean);
    return this.wrapIfNecessary(bean, beanName, cacheKey);
}
```

```java
protected Object wrapIfNecessary(Object bean, String beanName, Object cacheKey) {
    if (StringUtils.hasLength(beanName) && this.targetSourcedBeans.contains(beanName)) {
        return bean;
    } else if (Boolean.FALSE.equals(this.advisedBeans.get(cacheKey))) {
        return bean;
    } else if (!this.isInfrastructureClass(bean.getClass()) && !this.shouldSkip(bean.getClass(), beanName)) {
        Object[] specificInterceptors = this.getAdvicesAndAdvisorsForBean(bean.getClass(), beanName, (TargetSource)null);
        if (specificInterceptors != DO_NOT_PROXY) {
            this.advisedBeans.put(cacheKey, Boolean.TRUE);
            // 为给定的 bean 创建一个 AOP 代理。
            // 参数：
            // beanClass – bean 的类
            // beanName – bean 的名称
            // specificInterceptors – 特定于此 bean 的拦截器集（可能为空，但不为空）
            // targetSource – 代理的 TargetSource，已经预先配置为访问 bean
            // 返回：
            // bean 的 AOP 代理
            Object proxy = this.createProxy(bean.getClass(), beanName, specificInterceptors, new SingletonTargetSource(bean));
            this.proxyTypes.put(cacheKey, proxy.getClass());
            return proxy;
        } else {
            this.advisedBeans.put(cacheKey, Boolean.FALSE);
            return bean;
        }
    } else {
        this.advisedBeans.put(cacheKey, Boolean.FALSE);
        return bean;
    }
}
```

## 资料链接

https://jishuin.proginn.com/p/763bfbd2c640





