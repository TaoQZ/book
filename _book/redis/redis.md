# Redis

概述:是使用C语言开发的一个开源的高性能键值对数据库

特征:数据间没有必然的关联关系(mysql外键),内部采用单线程机制进行工作,高性能(官方测试数据为,50个并发执行100000个请求,读的速度是110000次/s,写的速度是81000次每秒),支持持久化

数据类型(key-value,指的是value的数据类型):

​	string:字符串,如果value是一个纯数字可对其进行数字操作,但其任然是一个字符串

​	hash:底层采用哈希表结构,key对应一片存储空间,存储field value的键值对

​	list:

​	set:

​	sorted_set:

应用:主要为热点数据加速查询,热点商品,新闻,资讯,访问量信息等;任务队列,如秒杀、抢购、购票排队等;即时信息查询,如各位排行榜在线人数信息



## 安装

使用docker安装

查看版本

需首先进入容器根目录

```shell
redis-server --version
# Redis server v=6.0.3 sha=00000000:0 malloc=jemalloc-5.1.0 bits=64 build=839141755a9d16cb
```

使用命令行需要进入/data文件夹使用命令启动客户端

```shell
redis-cli -p 6379
```

退出

```shell
quit
exit
```

help

```
# help 空格 接Tab键可以切换查看指定命令组的信息
# 或者直接接某个命令
help Tab | 命令
```

time

```
# 获取当前系统时间
# 秒
1) "1593921622"
2) "3230"
```



## 常用命令

### string类型

#### 基本操作

```shell
# 添加/修改 数据
set key value
# 获取数据,如果不存在返回 nil
get key 
# 删除数据,会返回Integer数字1代表成功 0代表失败 
del key 
# 添加/修改多个数据
mset key1 value1 key2 value2 ...
# 获取多个数据
mget key1 key2 ...
# 获取字符串个数
strlen key
# 追加信息,返回追加后字符串的长度
append key value
```

#### 对纯数值value操作

string在redis内部存储默认就是一个字符串,当遇到增减类操作,会自动转成数值型计算

redis所有的操作都是原子性的,采用单线程处理所有业务,命令时一个一个执行,因此无需考虑并发带来的数据影响

数值最大不可操作9223372036854775807(Java中Long类型最大值Long.MAX_VALUE)

基于以上特性,可以应用于控制多数据库时主键生成,保证主键唯一性

```shell
# 指定值可以为负数
# 自增1
incr key
# 自增指定值
incrby key 指定值
# 可以指定小数值,需要注意的是一旦成为小数,便不可再用incr或decr相关命令 : ERR value is not an integer or out of range	
incrbyfloat key 指定值
# 自减1
decr key
# 自减指定值
decrby key 指定值
```

#### 设置数据时效性(存活时间)

多应用于控制操作,比如投票,获取验证码等

```shell
# 一下操作需注意,如果有多次操作,最后操作会覆盖之前的操作
# 秒级
setex key seconds value
# 毫秒级
psetex key milliseconds value
```

#### 注意事项

数据操作返回值

​	1.运行结果: 0 : 失败 1 : 成功

​	2.运行后结果值: 比如strlen,incr等

数据未获取到 

​	(nil) : 等同于null

数据最大存储量 : 521MB

数值最大范围: 9223372036854775807(Java中Long类型最大值Long.MAX_VALUE)

key的设置约定: 表名:主键名:主键值:字段名:字段值

```shell
set user:id:1001:name:tao:age 18
```



### hash类型

可对一系列存储的数据进行编组,方便管理,典型应用存储对象信息;底层使用哈希表结构实现数据存储

hash存储结构优化: 如果field数量较少,存储结构优化为类数组结构,反之采用HashMap结构

也就是一个key对应一片存储空间,存储空间又可以存储多个 field -> value 的键值对

#### 基本操作

```shell
# 添加/修改数据
hset key field value
# 获取数据(指定字段)
hget key field
# 获取所有 field和value
hgetall key
# 使用hgetall命令的返回值,会将字段名和值都打印出来
1) "name"
2) "tao"
3) "age"
4) "18"
# 删除数据
hdel key

# 获取多个字段对应的值
hmget key field1 field2 ..
# 添加/修改多个字段
hmset key field1 value1 field2 value2
# 获取哈希表中子段的数量
hlen key
# 查看指定字段在哈希表中是否存在
hexists key field
```

#### 扩展操作

```shell
# 获取哈希表中所有字段名或字段值
hkeys key
hvals key
# 根据指定字段增加指定范围的值
hincrby key field increment
hincrbyfloat key field increment
```

```shell
# 如果hash表中字段不存在,添加否则不做操作
hsetnx key field value
```

#### 注意事项

​	hash类型下的value只能存储字符串,不允许存储其他数据类型,数据不存在返回 (nil)

​	每个hash可以存储 2的32次方-1 个键值对

​	hash类型贴近对象的数据存储形式,可以灵活的添加删除属性,但其设计初衷不是为了存储对象,不可滥用

​	hgetall操作在内部field过多时,整体遍历效率会很低,有可能成为数据访问的瓶颈



### list类型

存储多个数据,且通过数据可以体现进入顺序,底层使用双向链表存储

#### 基本操作

其中的l和r分别代表left和right,可以理解为可以分别从左边和右边添加获取并移除数据,而lrange只能从左边开始获取,按照相同方向则是栈操作,不同方向则是对列操作

```shell
# 添加/修改数据
# 从左添加数据
lpush key value1 value2 ...
# 从右添加数据
rpush key value1 value2 ...

# 获取数据 start和stop代表索引 0 -1 可以看到所有数据 -代表倒数第几个
lrange key start stop 
# 获取指定索引的数据
lindex key index 

# 获取并移除数据
lpop key
rpop key
```

#### 扩展操作

##### 阻塞获取

类似于消息队列功能

```shell
# 设置指定时间(秒)内获取,如果有值立刻返回
blpop key1 key2 ... timeoutr
brpop key1 key2 ... timeout
# 返回内容 数据所存在的集合 数据值 所用时间
1) "list2"
2) "10"
(15.29s)
```

```shell
# 删除指定元素 count: 删除符合value值的元素个数
lrem key count value
```

#### 注意事项

list中保存的数据都是string类型的,最多2的32次方-1个元素

list具有索引的概念,通常以对列或栈的方式操作



### set类型

存储大量数据,在查询方便有更高的效率,与hash结构完全相同,仅存储键,不存储值,其值不允许重复

#### 基本操作

```shell
# 添加数据
sadd key member1 member2 ...
# 获取全部数据
smembers key
# 删除数据
srem key member1 member2 ...
# 获取集合元素数量
scard key
# 判断集合是否包含指定元素
sismember key member
```

#### 扩展操作

```shell
# 随机获取集合中指定数量的数据,count可选,不选默认为1
srandmember key count
# 随机获取集合中某个数据并将其移出集合
spop key
```

求两个集合的交、并、差集

交集: 两个集合中相同的元素

并集: 两个集合去重后的所有元素

差集: 一个集合在另一个集合中没有的元素

```shell
sinter key1 [key2]
sunion key1 [key2]
sdiff key1 [key2]
```

求两个集合的交、并、差集并存储到指定集合中

```
sinterstore destination key1 [key2]
sunionstore destination key1 [key2]
sdiffstore destination key1 [key2]
```

将指定数据从源集合移动到目标集合中

```
smove source destination member
```

#### 注意事项

set类型不允许数据重复,如果添加的数据在set中已存在,将只保留一份

虽然与hash结构相同,但无法启用hash中存储值的空间



### sorted_set类型

基于set的存储结构添加可排序字段(score),可对数据进行整体排序,方便展示

#### 基本操作

```shell
# 添加/修改数据 score: 用于排序的数值
zadd key score1 member1 [score2 member2]
# 获取全部数据(根据score排序) withscores: 可选,返回的结果是否带score值
zrange key start stop [withscores]
# 倒序
zrevrange key start stop [withscores]
# 删除数据
zrem key member [member...]
```

```shell
# 按条件获取数据
zrangebyscore key min max [withscores] [limit offset count]
zrevrangebyscore key max min [withscores]
# 条件删除数据
zremrangebyrank key start stop
zremrangebyscore key min max
```

注意

​	min与max用于限定搜索查询的条件,包含min和max

​	start与stop用于限定查询范围,作用于索引,表示开始和结束索引,包含start和stop

​	offset与count用于限定查询范围,作用域查询结果,表示开始位置和数据总量

```shell
# 获取集合数据总量
zcard key
zcount key min max
# 集合交、并集操作(可以使用help命令查看更多用法)
# 求交集和并集会将相同的member的值相加(需注意)
zinterstore destination numkeys key [key...]
zunionstore destination numkeys key [key...]

zinterstore | zunionstore destination numkeys key [key...] [weights num...] [aggregate max | min]
```

注意

​	numkeys: 代表参与集合的个数

​	weights: 代表每个集合中的元素在参与aggregate前的权重值,元素与权重的乘积(默认为1)

​	aggregate: 可选max或min,选出经过元素与权重的乘积后最大或最小的元素(分组)





#### 扩展操作

```shell
# 获取数据对应的索引(排名),从0开始
zrank key member
zrevrank key member

# score值获取与修改
zscore key member
zincrby key increment member
```

注意事项

​	score数据存储空间为64位,score保存的数据可以是一个双精度的double值,基于双精度浮点数的特征,可能会出现数据精度丢失,sorted_set底层基于set,多个相同的数据添加时会覆盖score值(返回0,表示key虽然没有变,但是对应的score值变成了最后一次添加的score值)



### 通用操作指令

#### key通用操作

```shell
# 删除指定key
del key
# 获取key是否存在
exists key
# 获取key的类型
type key
```

```shell
# 为指定key设置有效期
expire key seconds
# 毫秒
pexpire key milliseconds
# 时间戳
expireat key timestamp
pexpireat key milliseconds-timestamp
```

```shell
# 获取key的有效时间 返回值: -1代表持久化 -2代表已过期 如果设置了有效期,但未过期显示剩余存活时间
ttl key
pttl key
# 切换key从时效性转换为永久性
persist key
```

```shell
# 查询key
keys pattern
```

匹配规则

​	*: 匹配任意数量的任意符号

​	?: 匹配一个任意符号

​	[]: 匹配任意一个指定符号

比如

```shell
# 所有key
keys *
# 以zz开头的key
keys zz*
# 以zz结尾的key
keys *zz
# 开头以任意三个字符开头,以tao结尾,也就是key总长要在6
keys ???tao
# 中间任意匹配其中一个字符,以ao结尾
keys t[aqz]ao
```

```sh
# 为key改名
# 如果存在同名的key,覆盖原来的key中的数据
rename key newKey
# 如果指定name的key不存在时执行
renamenx key newKey
# 对所有key排序,key对应的类型必须是一个list或set
sort key
```

#### db通用操作

redis分为0-15数据库

```shell
# 切换数据库
select number
# 测试是否与服务器连通,成功返回pong
ping 
# 打印字符串
echo message
```

```shell
# 数据移动
move key db
# 当前库key数量
dbsize
# 数据清除
flushdb
flushall
```



## Java操作Redis

创建maven项目,导入依赖

```xml
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
    <version>2.9.0</version>
</dependency>
```

创建工具类

```java
public class JedisUtils {
    private static JedisPool jp = null;
    private static String host = null;
    private static int port;
    private static int maxTotal;
    private static int maxIdle;

    static {
        ResourceBundle rb = ResourceBundle.getBundle("redis_zh_CN");
        host = rb.getString("redis.host");
        port = Integer.parseInt(rb.getString("redis.port"));
        maxTotal = Integer.parseInt(rb.getString("redis.maxTotal"));
        maxIdle = Integer.parseInt(rb.getString("redis.maxIdle"));
        JedisPoolConfig jpc = new JedisPoolConfig();
        jpc.setMaxTotal(maxTotal);
        jpc.setMaxIdle(maxIdle);
        jp = new JedisPool(jpc,host,port);
    }

    public static Jedis getJedis(){
        return jp.getResource();
    }
    public static void main(String[] args){
        JedisUtils.getJedis();
    }
}
```

在resource文件夹下创建redis_zh_CN.properties配置文件

```properties
redis.host=127.0.0.1
redis.port=6379
redis.maxTotal=30
redis.maxIdle=10
```

```java
public static void main(String[] args) {
    // 获取连接
    Jedis jedis = JedisUtils.getJedis();
    // 测试连接
    // Jedis操作redis的方法与命令行基本一致
    String ping = jedis.ping();
    System.out.println(ping);
    // 关闭连接
    jedis.close();
}
```