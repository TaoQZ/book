# Java 8 日期时间 API

​		在旧版的Java中,日期时间API主要在java.util包下,但其存在许多问题,比如java.util.Date是非线程安全的,所有的日期类都是可变的。从Java8开始,Java API中已经能够提供高质量的日期和时间支持,java.time包,并且日期时间都是不可变和线程安全的



## LocalDate

该类是一个不可变的和线程安全的;表示日期,通常被视为年月日,该类不存储或表示时区

```java
public class LocalDateDemo {

    public static void main(String[] args) {

        // LocalDate 不可变,线程安全的日期类 年月日
        // 获取当前日期 默认格式:yyyy-MM-dd 根据系统的时钟和时区获取日期
        LocalDate date = LocalDate.now();
        // 年
        int year = date.getYear();
        // 月
        int monthValue = date.getMonthValue();
        // 日(号)
        int dayOfMonth = date.getDayOfMonth();
        System.out.println(date);
        System.out.println(year+"年/"+monthValue+"("+date.getMonth()+")月/"+dayOfMonth+"日");
        // 星期
        int week = date.getDayOfWeek().getValue();
        System.out.println("星期:"+week+"==="+date.getDayOfWeek());

        // 当年中的第几天
        int dayOfYear = date.getDayOfYear();
        // 当月的总天数
        int monthLength = date.lengthOfMonth();
        // 当年的总天数
        int yearLength = date.lengthOfYear();

        System.out.println("几天是本年的第"+dayOfYear+"天");
        System.out.println("本月的总天数为:"+monthLength);
        System.out.println("当年的总天数为:"+yearLength);

        System.out.println(date.isLeapYear() ? "闰年" : "平年");
    }


    @Test
    public void fun(){

//        在创建LocalDate时会对日期进行校验,如果任何字段的值超出范围，或者如果月的日期对于月份无效将抛出异常
//        java.time.DateTimeException: Invalid date 'February 29' as '2019' is not a leap year
//        2019年不是闰年,所以2月没有29号
//        LocalDate of = LocalDate.of(2019, 2, 29);
//        虽然2020年时闰年,但是2月份最多只有29天
//        java.time.DateTimeException: Invalid date 'FEBRUARY 30'
//        LocalDate of = LocalDate.of(2020, 2, 30);
        LocalDate of = LocalDate.of(2020, 2, 29);
        System.out.println(of);

//        根据一年中的第一天创建对象
        LocalDate date = LocalDate.ofYearDay(2020, 32);
        System.out.println(date);

//        参数需要一个正确的日期格式 年-月-日
//        严格按照yyyy-MM-dd的格式验证 需补0
//        LocalDate parse = LocalDate.parse("1999-10-9");
        LocalDate parse = LocalDate.parse("1999-10-09");
        System.out.println(parse);

//        查看指定日期是否在参数日期之前, 其他还有 之后,相等方法来比较日期
        boolean after = parse.isBefore(LocalDate.now());
        System.out.println(after);

    }
}
```

## LocalTime

该类是一个不可变的和线程安全的;表示时间,通常被视为时分秒,该类不存储或表示时区

```java
public class LocalTimeDemo {

    public static void main(String[] args) {

        // LocalTime 不可变线程安全的时间类
        // 默认格式 时:分:秒:纳秒(nanosecond)
        LocalTime now = LocalTime.now();
        System.out.println(now);

        // 指定时分秒创建对象
        LocalTime of = LocalTime.of(18, 30,48);
        System.out.println(of);
        System.out.println(of.getHour()+"时"+of.getMinute()+"分"+of.getSecond()+"秒");

        // 减去指定的Hour并返回对象 同样可减去分秒纳秒
        LocalTime minusHours = of.minusHours(2);
        System.out.println(minusHours);

        // 增加指定的Minute 同样可增加时秒纳秒
        LocalTime plusMinutes = of.plusMinutes(29);
//        of.plusNanos(12);
        System.out.println(plusMinutes);

//      根据文本解析为LocalTime对象
//      严格按照HH:mm:ss的格式验证 需补0
//        LocalTime parse = LocalTime.parse("09:20:6");
        LocalTime parse = LocalTime.parse("09:20:06");
        System.out.println(parse);

        boolean after = of.isAfter(now);
        System.out.println("是否在当前时间之后:"+after);

    }


    @Test
    public void demo(){
        LocalTime of = LocalTime.of(18, 30,38,199);
//        java.time.DateTimeException: Invalid value for HourOfDay (valid values 0 - 23): 24
//        从0-23来表示时间
//        将时间改为指定参数值,相当于进行set
        LocalTime localTime = of.withHour(6).withMinute(10);
        System.out.println(localTime);
        // 获取当前时间总秒数
        int i = localTime.toSecondOfDay();
        System.out.println(i);
        // 将秒数转为LocalTime对象
        LocalTime ofSecondOfDay = LocalTime.ofSecondOfDay(i);
        System.out.println(ofSecondOfDay);

//        System.out.println(of);
//        System.out.println(of.getNano());
    }
}		
```

## LocalDateTime

上面的两个类一个表示日期,一个表示时间,而该类更像是将两者结合起来,通过观看源码得知,它确实也是这么做的

构造是个私有的,一个参数是LocalDate另一个则是LocalTime

```java
public class LocalDateTimeDemo {

    public static void main(String[] args) {

//      获取当前日期加时间
//      效果是其LocalDate和LocalTime的合体,同时代表了日期和时间 使用系统时区
        LocalDateTime now = LocalDateTime.now();
//      打印格式  2020-03-16T20:49:02.450
        System.out.println(now);

//        同样可以根据字符串解析为对象 其中T是必须的表示时间的开始
//        并且严格按照yyyy-MM-ddTHH:mm:ss的格式进行验证,需补0
//        LocalDateTime parse = LocalDateTime.parse("2001-12-9T10:22:36");
        LocalDateTime parse = LocalDateTime.parse("2001-12-09T10:22:36");
        System.out.println(parse);

//      根据指定的日期和时间创建对象
        LocalDateTime of = LocalDateTime.of(2020, 2, 20, 15, 30,36);
        System.out.println(of);
//      通过查看其 of 方法的实现发现其实使用了之前两个日期时间类的构造
//      上面创建方式和本方式创建对象一致
        LocalDate localDate = LocalDate.of(2020, 2, 20);
        LocalTime localTime = LocalTime.of(15, 30, 36);
//      该类的构造方法的是私有的,该方式是因为该类提供了静态的of方法,在方法内部使用其构造方法new的方式创建对象
        LocalDateTime localDateTime = LocalDateTime.of(localDate, localTime);

//      true
        System.out.println(of.isEqual(localDateTime));

//        同样LocalDate和LocalTime可以使用自身的     atXXXX  来进行组合返回一个完整的LocalTime对象
        LocalDateTime localDateTime1 = localDate.atTime(localTime);
        LocalDateTime localDateTime2 = localTime.atDate(localDate);

//        并且可以灵活转换
//        LocalDate date = localDateTime1.toLocalDate();
//        LocalTime time = localDateTime1.toLocalTime();

//		 比较日期时间是否一致        
        System.out.println(localDateTime1.isEqual(localDateTime2));

    }

    @Test
    public void demo(){

        LocalDateTime now = LocalDateTime.now();
        System.out.println(now);
        //   withXXXX 用于修改为指定的日期或时间
        //   plusXXXX 用于将日期或时间和参数相加
        //   minusXXXX 用于将日期或时间减去相应的参数值
        LocalDateTime withHour = now.withHour(2).plusMinutes(20).minusSeconds(5);
        System.out.println(withHour);
    }
}
```

## DateTimeFormatter

在java8之前使用的SimpleDateFormat可能会出现线程安全的问题,而在Java8中新提供的DateTimeFormatter可以解决这个问题,该类也主用于日期时间的解析和格式化。这个类是不可变的和线程安全的。

```java
public class DateTimeFormatterDemo {

    public static void main(String[] args) {

//        按照格式进行相互转换
        LocalDateTime now = LocalDateTime.of(2020,03,16,22,59,23);
        System.out.println(now);
        String format = now.format(DateTimeFormatter.BASIC_ISO_DATE);
//        20200316
        System.out.println(format);
//        22:59:23
        format = now.format(DateTimeFormatter.ISO_LOCAL_TIME);
//        2020-03-16
        System.out.println(format);

        LocalDate localDateParse = LocalDate.parse("20200316", DateTimeFormatter.BASIC_ISO_DATE);
//        2020-03-16
        System.out.println(localDateParse);

        LocalTime localTimeParse = LocalTime.parse("22:59:23.017", DateTimeFormatter.ISO_LOCAL_TIME);
//        22:59:23.017
        System.out.println(localTimeParse);

    }

    /**
     * 自定义格式
     */
    @Test
    public void demo(){
        // 从模式创建的格式化程序可以根据需要多次使用，它是不可变的并且是线程安全的。 
        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy/MM/dd");
//        按照指定格式将日期格式化
        String format = LocalDateTime.now().format(dateTimeFormatter);
//        2020/03/16
        System.out.println(format);

//        根据指定的格式将字符串再转为对象
        LocalDate parse = LocalDate.parse(format, dateTimeFormatter);
//       2020-03-16
        System.out.println(parse);

//        根据给定字符串,创建匹配规则并转为时间对象
        String time = "18时12分40秒";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH时mm分ss秒");
        LocalTime localTime = LocalTime.parse(time, formatter);
        System.out.println(localTime);
    }
}

```

## TemporalAdjusters

java8之前的java.util包中的Date类,它提供了公开的修改时间的方法,因此可以轻松的修改时间

而在Java8中新的时间API,表示时间的类都是不可变的,类本身和变量都被final修饰,所以是不可变的,因此又提供了该类用于进行日期时间的复杂操作,但也正因为这些类都是不可变的所以使用该类产出的对象都是一个新的日期或时间对象

虽然没有直观的setXxxx方法,但是也提供了对应的withXxxx方法,和set方法功能一致,只不过同样是产出新的对象

```java
import static java.time.temporal.TemporalAdjusters.*;
public class TemporalAdjusterDemo {

    public static void main(String[] args) {

        LocalDateTime now = LocalDateTime.now();
        System.out.println(now);

        LocalDateTime with;
//        根据ordinal的值 进行计算将日期调整为计算后的week
        with = now.with(dayOfWeekInMonth(-6,DayOfWeek.SUNDAY));
//        创建一个新的日期,将日期调整为该月份的第一天
        with = now.with(firstDayOfMonth());
//        创建一个新的日期,将日期调整为下个月的第一天
        with = now.with(firstDayOfNextMonth());
//        创建一个新的日期,将日期调整为当年的第一天
        with = now.with(firstDayOfYear());
//        创建一个新的日期,将日期调整为下一年的第一天
        with = now.with(firstDayOfNextYear());
//        创建一个新的日期,将日期调整为第一个指定的星期
        with = now.with(firstInMonth(DayOfWeek.SUNDAY));
//        创建一个新的日期,将日期调整为当月的最后一天
        with = now.with(lastDayOfMonth());
//        创建一个新的日期,将日期调整为当年的最后一天
        with = now.with(lastDayOfYear());
//        创建一个新的日期,将日期调整为当月的最后一个指定的星期
        with = now.with(lastInMonth(DayOfWeek.THURSDAY));
//        创建一个新的日期,将日期调整为下一周指定的星期
        with = now.with(next(DayOfWeek.MONDAY));
//        创建一个新的日期,将日期调整为下一个指定的星期,如果当前星期和参数一致则直接返回
        with = now.with(nextOrSame(DayOfWeek.THURSDAY));
//        创建一个新的日期,将日起调整为上一个指定的星期
        with = now.with(previous(DayOfWeek.FRIDAY));
//        创建一个新的日期,将日期调整为上一个指定的星期,如果该日期的星期和参数一致则直接返回
        with = now.with(previousOrSame(DayOfWeek.WEDNESDAY));

        System.out.println(with);
//        false
//        因为java.time中的日期时间类的成员变量都是final的也就是不可变的
//        所以with方法并不是修改而是创建新的对象
        System.out.println(with == now);

//        可以看到java.util包中中的日期类,提供了public公共的修改访问方法,在并发量大的情况下可能会出现问题
//        Date date = new Date();
//        date.setTime();
    }


    @Test
    public void demo(){
        LocalDateTime now = LocalDateTime.now();
//      Period可以对日期进行操作
        LocalDateTime with = now.with(t -> t.plus(Period.ofWeeks(1)));
        System.out.println(with);
    }

}
```



## ZonedDateTime、Instant

前面的日期时间对象都是本地时间但没有时区信息

Instant是世界标准时间且不含时区信息

ZonedDateTime则可以配合ZoneId处理时区,本质是用Instant存储时间,在根据时区进行处理

```java
public class ZoneRulesDemo {

    public static void main(String[] args) {

//        获取内置的所有时区信息 value为 区域/城市 比如 Asia/Shanghai 亚洲/上海
        ZoneId.SHORT_IDS.forEach((key,value) -> System.out.println(key+"==="+value));

//        TimeZone是java8之前的时区对象,将其转为最新的时区对象并获取当前系统的时区
        ZoneId aDefault = TimeZone.getDefault().toZoneId();
        System.out.println(aDefault);

        LocalDateTime now = LocalDateTime.now();

//        将当前时区转为指定时区
        ZoneId of = ZoneId.of("America/Chicago");
        System.out.println(LocalDateTime.ofInstant(now.atZone(ZoneId.systemDefault()).toInstant(),of));
        System.out.println(LocalDateTime.ofInstant(Instant.now(),of));

    }


    /**
     * https://blog.csdn.net/u012107143/article/details/78790378
     * 表示时间的主要类: String LocalDateTime Instant ZonedDateTime
     */
    @Test
    public void demo(){

//        2020-03-16T16:05:59.793Z  T代表时间的开始 Z表示这是一个世界标准时间 +00:00
        System.out.println(Instant.now());
//        2020-03-17T00:07:08.203 本地时间,不含时区信息的时间
        System.out.println(LocalDateTime.now());
        System.out.println(LocalDateTime.now(ZoneId.of("+00:00")));
//        2020-03-17T00:07:08.203+08:00[Asia/Shanghai] 本地时间并且显示时区信息
        System.out.println(ZonedDateTime.now());
        System.out.println(ZonedDateTime.now(ZoneId.of("+00:00")));

//        三个类构造对象的不同方式
//        使用毫秒从1970-01-01T00开始获得的一个实例 Instant 世界标准时间
        Instant instant = Instant.ofEpochMilli(System.currentTimeMillis());
        System.out.println(instant);

        LocalDateTime localDateTime = LocalDateTime.of(2020, 02, 20, 18, 30, 16);
        System.out.println(localDateTime);

//        根据指定时区创建对象
        ZonedDateTime zonedDateTime = ZonedDateTime.of(localDateTime, ZoneId.of("Africa/Cairo"));
//        ZonedDateTime zonedDateTime = ZonedDateTime.of(localDateTime, ZoneId.systemDefault());
        System.out.println(zonedDateTime);


    }


    /**
     *  其中String和LocalDateTime是等价的,两者可以通过DateTimeFormatter进行相互转换
     */
    @Test
    public void stringLocalDateTimeDemo(){
        String dateTime = "2020/02/20 18:30:36";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
        LocalDateTime parse = LocalDateTime.parse(dateTime, formatter);
        System.out.println(parse);
        String format = parse.format(formatter);
        System.out.println(format);
    }

    /**
     * Instant和ZonedDateTime是等价的
     */
    @Test
    public void instantZonedDateTime(){

        ZonedDateTime zonedDateTime1 = Instant.now().atZone(ZoneId.systemDefault());
        ZonedDateTime zonedDateTime2 = Instant.now().atZone(ZoneId.of("America/Chicago"));

        System.out.println(zonedDateTime1);
        System.out.println(zonedDateTime1.toInstant());
        System.out.println(zonedDateTime1.toLocalDate());

        System.out.println(Instant.now().atZone(ZoneId.of("+00:00")));

        System.out.println(zonedDateTime2);
        System.out.println(zonedDateTime2.toInstant());
        System.out.println(zonedDateTime2.toLocalDate());

//        通过结果可以看出 根据系统时区和根据其他时区创建的ZonedDateTime对象内部的时间戳Instant和标准时间都是一致的
//        只不过加了时区之后,对时区进行了处理
//        相当于对Instant做了增强
        /*
        2020-03-17T01:02:56.253+08:00[Asia/Shanghai]
        2020-03-16T17:02:56.253Z
        2020-03-17
        2020-03-16T17:02:56.334Z
        2020-03-16T12:02:56.317-05:00[America/Chicago]
        2020-03-16T17:02:56.317Z
        2020-03-16
        */

    }

    @Test
    public void exchange(){
        Instant instant = Instant.now();
        LocalDateTime localDateTime = LocalDateTime.ofInstant(instant, ZoneId.systemDefault());
//        系统默认的时区就是该时区,另一种写法
        ZonedDateTime zonedDateTime = ZonedDateTime.ofInstant(instant, ZoneId.of("Asia/Shanghai"));

//        LocalDateTime转为ZonedDateTime
        ZonedDateTime of = ZonedDateTime.of(localDateTime, ZoneId.systemDefault());
//        ZonedDateTime转为LocalDateTime
        LocalDate localDate = zonedDateTime.toLocalDate();

        Instant instant1 = zonedDateTime.toInstant();
        System.out.println(instant1);
//        LocalDateTime转换Instant时需要指定时区,时区必须是时区对应的时间
        Instant instant2 = localDateTime.toInstant(ZoneOffset.of("+08:00"));
        System.out.println(instant2);

    }
}

```

## 时间戳、时区

理解时间戳和时区

时间戳:指的是Unix时间戳,是一种时间的表示方式,在地球的每一个角落都是相同的,从格林威治时间1970年01月01日00时00分00秒起至现在的总秒数

可以使用网站查询时间戳:http://tool.chinaz.com/Tools/unixtime.aspx

使用时间戳获取总秒数

```java
   @Test
    public void demo3(){
        long epochSecond = Instant.now().getEpochSecond();
        System.out.println(epochSecond);
    }	
```

时区:时间戳在地球的任何位置都是相同的,但是相同的时间点会有不同的表达方式,就是时区的概念。比如我们在中国是白天,而在美国正是夜晚,但是我们过的时间都是一样的,这时便需要使用时区来相互转换获取对方时区的具体时间

```java
  @Test
    public void fun(){
//        获取所有jdk内置的时区信息
        ZoneId.SHORT_IDS.forEach((e1,e2) -> System.out.println(e1+"=="+e2));
//        根据本地时区获取信息的时间
        ZonedDateTime asiaShangha = ZonedDateTime.now();
//        根据指定的时区获取时间 这里使用的是美国纽约
        ZonedDateTime americaNewYork = ZonedDateTime.ofInstant(Instant.now(), ZoneId.of("America/New_York"));
//        分别打印对方所在时区的具体时间
        System.out.println(asiaShangha);
        System.out.println(americaNewYork);
//        获取时间戳总秒数,可以看到是相同的
        System.out.println(asiaShangha.toInstant().getEpochSecond());
        System.out.println(americaNewYork.toInstant().getEpochSecond());
    }
```

控制台打印信息

```
CTT==Asia/Shanghai
ART==Africa/Cairo
CNT==America/St_Johns
PRT==America/Puerto_Rico
PNT==America/Phoenix
PLT==Asia/Karachi
AST==America/Anchorage
BST==Asia/Dhaka
CST==America/Chicago
EST==-05:00
HST==-10:00
JST==Asia/Tokyo
IST==Asia/Kolkata
AGT==America/Argentina/Buenos_Aires
NST==Pacific/Auckland
MST==-07:00
AET==Australia/Sydney
BET==America/Sao_Paulo
PST==America/Los_Angeles
ACT==Australia/Darwin
SST==Pacific/Guadalcanal
VST==Asia/Ho_Chi_Minh
CAT==Africa/Harare
ECT==Europe/Paris
EAT==Africa/Addis_Ababa
IET==America/Indiana/Indianapolis
MIT==Pacific/Apia
NET==Asia/Yerevan
2020-03-18T11:15:09.033+08:00[Asia/Shanghai]
2020-03-17T23:15:09.034-04:00[America/New_York]
1584501309
1584501309
```



## SpringBoot针对新日期时间API的转换

方式一:只针对某个字段,需要在每个需要格式化的字段上添加该注解

```java
@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
private LocalDateTime sendDate;
```

方式二:全局配置,针对所有的LocalDate以及LocalDateTime字段进行格式化

```java
@Configuration
public class ContactAppConfig{
    private static final String dateFormat = "yyyy-MM-dd";

    private static final String dateTimeFormat = "yyyy-MM-dd HH:mm:";

    @Bean
    public Jackson2ObjectMapperBuilderCustomizer jsonCustomizer(){
        return builder ->{
            builder.simpleDateFormat(dateTimeFormat);
            builder.serializers(new
                    LocalDateSerializer(DateTimeFormatter.ofPattern(dateFormat)));
            builder.serializers(new
                    LocalDateTimeSerializer(DateTimeFormatter.ofPattern(dateTimeFormat)));
        };
    }
}
```







