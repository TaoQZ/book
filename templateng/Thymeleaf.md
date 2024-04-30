---
typora-root-url: img
---

# Thymeleaf

​	Thymeleaf是一个模板引擎,可以完全代替JSP,解决了JSP在服务器未启动时不能预览的弊端,在后台给出真实数据时可以动态将预览数据替换,可以让前后端人员方便的进行预览和查看数据,也是SpringBoot的推荐模板引擎之一

​	

## 所需依赖及配置

​	以下所有配置基于springboot

​	开发环境

- Spring Boot 2.1.6
- Thymeleaf 3.0.11
- Jdk 8
- Windows 10
- IDEA 2019

​	**pom文件所需依赖**

```java
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```

​	**模板位置**

```
默认的映射路径:src/main/resources/templates
```

​	**properties**

```yml
#页面不加载缓存，修改即时生效
spring.thymeleaf.cache=false
# 模版存放路径
spring.thymeleaf.prefix=classpath:/templates/
# 模版后缀
spring.thymeleaf.suffix=.html
```



## 与springboot整合热部署

​	**idea中所需配置**

​	**双击shift键搜索registry 将下图中第一个选项点勾**

![](/../../img/thymeleaf/registry.png)

**setting中配置下图**

![](../../img/thymeleaf//setting.png)

设置完毕后thymeleaf模板引擎的热部署就完成了

使用:

​	页面修改后在Java文件中使用快捷键Shift+Ctrl+F9进行重新编译Recompile,这样只会更改页面中的内容,Java文件如果修改则不会改变

​	解决:

​		在pom文件中引入

```java
 <!--热部署配置-->
 <dependency>
	 <groupId>org.springframework.boot</groupId>
	 <artifactId>spring-boot-devtools</artifactId>
 </dependency>
 
   <build>
       <plugins>
           <plugin>
               <groupId>org.springframework.boot</groupId>
               <artifactId>spring-boot-maven-plugin</artifactId>
               <configuration>
               		<fork>true</fork> 
               </configuration>
           </plugin>
       </plugins>
   </build>
```

​		properties:

```yml
#开启热部署
spring.devtools.restart.enabled=true
#也可以单独设置重启目录 不用手动 有弊端修改页面仍然需要重新编译
#spring.devtools.restart.additional-paths=src/main/java
```

设置完成后springboot+Thymeleaf的热部署就真正完成了



## 简单上手

**index.html**

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<p th:text="${hello}">2333</p>
</body>
</html>
```

**controller**

```java
@Controller
public class HelloController {

    @RequestMapping("/hello")
    public String fun(Model model){
        model.addAttribute("hello","hello thymeleaf");
        return "index";
    }

}
```

如果直接打开显示的是其初始值2333

运行服务器打开后的网页显示的是后台传来的实体数据

## 语法

​	完成上面的操作也是方便我们进行测试

#### 	1.引入提示

​		在html页面引入命名空间

```html
<html xmlns:th="http://www.thymeleaf.org">
```

#### 	**2.常用标签**

##### 		2.1.URL表达式

###### 			 2.1.1. th:href th:src 引入css和js

```html
<!-- 引入css 一定要加rel  -->
<link rel="stylesheet" th:href="@{/css/main.css}" />
<!--  引入js  -->
<script th:src="@{/js/jquery-3.0.0.js}"></script>
```

###### 			2.1.2. th:fragment th:replace 引入重复代码

```html
header.html
为标签起个名字
<head th:fragment="header-fragment">
	<!--  省略引入资源  -->
</head

其他.html
replace 是将引用过来的标签进行替换
其中冒号前为引用的html名称,后面则是引用的具体的标签的名称
<header th:replace="/header::header-fragment"></header>
```

###### 			2.1.3. th:href 超链接

```html
  可以传值也可以直接给值
  <a th:href="@{${baidu}}">百度</a>
  <a th:href="@{https://www.baidu.com}">百度</a>
  带参数
  <a th:href="@{controller(name=zz,age=12)}">taoqz</a>
  会被解释成:/controller?name=zz&age=12
```

##### 	2.2.变量表达式

###### 		2.2.1. th:text th:utext 获取单个值

```html
 服务器启动后,如果没有此名称的数据,显示为空白 
 如果是引用数据类型,本身为null也会显示空白,如果是null访问其属性会报错
 <div th:text="${user}">服务器启动后,如果有值会被替换</div>
 
 上面是原样输出,下面可以输出后台传来的html,并且识别样式
 <div th:utext="${html}"></div>
 model.addAttribute("html","<font color='red'>user</font>");
```

###### 		2.2.2. th:each 循环遍历之list

```html

    <table border="1px">
        <thead>
            <tr>
                <th>
                    NAME
                </th>
                <th>
                    AGE
                </th>
            </tr>
        </thead>
        <tbody>
            <tr th:each="user : ${users}">
                <td th:text="${user.name}"></td>
                <td th:text="${user.age}"></td>
            </tr>
        </tbody>
    </table>
```

###### 2.2.3. th:each 循环遍历之map

```html

<table border="1px">
    <thead>
        <tr>
            <th>序号</th>
            <th>KEY</th>
            <th>value.name</th>
            <th>value.age</th>
        </tr>
    </thead>
    <tbody>
        <tr th:each="user,userStatus:${map}">
            <td th:text="${userStatus.index}+1"></td>
            <td th:text="${user.key}"></td><!-- key-->
            <td th:text="${user.value.name}"></td><!-- value-->
            <td th:text="${user.value.age}"></td><!-- value-->
        </tr>
    </tbody>
</table>

<ul th:each="user : ${map}">
    <li th:each="every : ${user}" th:text="${every.key}" ></li>
    <li th:each="every : ${user}" th:text="${every.value.name}"></li>
    <li th:each="every : ${user}" th:text="${every.value.age}"></li>
</ul>
```

**userStatus:遍历状态**

![1567269389524](/../img/thymeleaf/状态变量.png)

###### 	2.2.4.th:if th:unless 条件判断

```html
	<!-- 条件成立执行 -->
    <span th:if="${age >= 18}">
        成年
    </span>
    <!-- 条件不成立执行   -->
    <span th:unless="${age >= 18}">
        未成年
    </span>
```

###### 	2.2.5. th:switch th:case

```html
<div th:switch="${age}">
    <span th:case="18">18岁</span>
    <span th:case="19">19岁</span>
    <spa th:case="*">其他</spa>
</div>
```

###### 	2.2.5. th:block

​		定义一个代码块,并且可以执行里面的属性

#### 2.3.选择或星号表达式

```html
<div th:object="${session.user}">
    <p>Name: <span th:text="*{firstName}">Sebastian</span>.</p>
    <p>Surname: <span th:text="*{lastName}">Pepper</span>.</p>
    <p>Nationality: <span th:text="*{nationality}">Saturn</span>.</p>
</div>

//等价于
<div>
    <p>Name: <span th:text="${session.user.firstName}">Sebastian</span>.</p>
    <p>Surname: <span th:text="${session.user.lastName}">Pepper</span>.</p>
    <p>Nationality: <span th:text="${session.user.nationality}">Saturn</span>.</p>
</div>
```

#### 2.4. 三元运算符

if-then :(如果）？（然后）

```html
<span th:class="${title1} ? 'green'">样例</span>
```

if-then-else :(如果）？（那么）:(否则）

```html
<span th:class="${title} ? 'green' :' red'">样例一</span>
```

默认:(值）？:(默认值）

```html
 <span th:text="*{age}?: '(no age specified)'">20</span>
```



### 3.工具类

```yml
#dates: java.util的实用方法。对象:日期格式、组件提取等.
#calendars: 类似于#日期,但对于java.util。日历对象
#numbers: 格式化数字对象的实用方法。
#strings:字符串对象的实用方法:包含startsWith,将/附加等。
#objects: 实用方法的对象。
#bools: 布尔评价的实用方法。
#arrays: 数组的实用方法。
#lists: list集合。
#sets:set集合。
#maps: map集合。
#aggregates: 实用程序方法用于创建聚集在数组或集合.
#messages: 实用程序方法获取外部信息内部变量表达式,以同样的方式,因为他们将获得使用# {…}语法
#ids: 实用程序方法来处理可能重复的id属性(例如,由于迭代)。
#httpServletRequest:用于web应用中获取request请求的参数
#session:用于web应用中获取session的参数
```

```yml
Dates

#dates : utility methods for java.util.Date objects:
/*
* ======================================================================
* See javadoc API for class org.thymeleaf.expression.Dates
* ======================================================================
*/

/*
* Null-safe toString()
*/
${#strings.toString(obj)}                           // also array*, list* and set*

/*
* Format date with the standard locale format
* Also works with arrays, lists or sets
*/
${#dates.format(date)}
${#dates.arrayFormat(datesArray)}
${#dates.listFormat(datesList)}
${#dates.setFormat(datesSet)}

/*
* Format date with the specified pattern
* Also works with arrays, lists or sets
*/
${#dates.format(date, 'dd/MMM/yyyy HH:mm')}
${#dates.arrayFormat(datesArray, 'dd/MMM/yyyy HH:mm')}
${#dates.listFormat(datesList, 'dd/MMM/yyyy HH:mm')}
${#dates.setFormat(datesSet, 'dd/MMM/yyyy HH:mm')}

/*
* Obtain date properties
* Also works with arrays, lists or sets
*/
${#dates.day(date)}                    // also arrayDay(...), listDay(...), etc.
${#dates.month(date)}                  // also arrayMonth(...), listMonth(...), etc.
${#dates.monthName(date)}              // also arrayMonthName(...), listMonthName(...), etc.
${#dates.monthNameShort(date)}         // also arrayMonthNameShort(...), listMonthNameShort(...), etc.
${#dates.year(date)}                   // also arrayYear(...), listYear(...), etc.
${#dates.dayOfWeek(date)}              // also arrayDayOfWeek(...), listDayOfWeek(...), etc.
${#dates.dayOfWeekName(date)}          // also arrayDayOfWeekName(...), listDayOfWeekName(...), etc.
${#dates.dayOfWeekNameShort(date)}     // also arrayDayOfWeekNameShort(...), listDayOfWeekNameShort(...), etc.
${#dates.hour(date)}                   // also arrayHour(...), listHour(...), etc.
${#dates.minute(date)}                 // also arrayMinute(...), listMinute(...), etc.
${#dates.second(date)}                 // also arraySecond(...), listSecond(...), etc.
${#dates.millisecond(date)}            // also arrayMillisecond(...), listMillisecond(...), etc.

/*
* Create date (java.util.Date) objects from its components
*/
${#dates.create(year,month,day)}
${#dates.create(year,month,day,hour,minute)}
${#dates.create(year,month,day,hour,minute,second)}
${#dates.create(year,month,day,hour,minute,second,millisecond)}

/*
* Create a date (java.util.Date) object for the current date and time
*/
${#dates.createNow()}

/*
* Create a date (java.util.Date) object for the current date (time set to 00:00)
*/
${#dates.createToday()}
Calendars

#calendars : analogous to #dates, but for java.util.Calendar objects:
/*
* ======================================================================
* See javadoc API for class org.thymeleaf.expression.Calendars
* ======================================================================
*/

/*
* Format calendar with the standard locale format
* Also works with arrays, lists or sets
*/
${#calendars.format(cal)}
${#calendars.arrayFormat(calArray)}
${#calendars.listFormat(calList)}
${#calendars.setFormat(calSet)}

/*
* Format calendar with the specified pattern
* Also works with arrays, lists or sets
*/
${#calendars.format(cal, 'dd/MMM/yyyy HH:mm')}
${#calendars.arrayFormat(calArray, 'dd/MMM/yyyy HH:mm')}
${#calendars.listFormat(calList, 'dd/MMM/yyyy HH:mm')}
${#calendars.setFormat(calSet, 'dd/MMM/yyyy HH:mm')}

/*
* Obtain calendar properties
* Also works with arrays, lists or sets
*/
${#calendars.day(date)}                // also arrayDay(...), listDay(...), etc.
${#calendars.month(date)}              // also arrayMonth(...), listMonth(...), etc.
${#calendars.monthName(date)}          // also arrayMonthName(...), listMonthName(...), etc.
${#calendars.monthNameShort(date)}     // also arrayMonthNameShort(...), listMonthNameShort(...), etc.
${#calendars.year(date)}               // also arrayYear(...), listYear(...), etc.
${#calendars.dayOfWeek(date)}          // also arrayDayOfWeek(...), listDayOfWeek(...), etc.
${#calendars.dayOfWeekName(date)}      // also arrayDayOfWeekName(...), listDayOfWeekName(...), etc.
${#calendars.dayOfWeekNameShort(date)} // also arrayDayOfWeekNameShort(...), listDayOfWeekNameShort(...), etc.
${#calendars.hour(date)}               // also arrayHour(...), listHour(...), etc.
${#calendars.minute(date)}             // also arrayMinute(...), listMinute(...), etc.
${#calendars.second(date)}             // also arraySecond(...), listSecond(...), etc.
${#calendars.millisecond(date)}        // also arrayMillisecond(...), listMillisecond(...), etc.

/*
* Create calendar (java.util.Calendar) objects from its components
*/
${#calendars.create(year,month,day)}
${#calendars.create(year,month,day,hour,minute)}
${#calendars.create(year,month,day,hour,minute,second)}
${#calendars.create(year,month,day,hour,minute,second,millisecond)}

/*
* Create a calendar (java.util.Calendar) object for the current date and time
*/
${#calendars.createNow()}

/*
* Create a calendar (java.util.Calendar) object for the current date (time set to 00:00)
*/
${#calendars.createToday()}
Numbers

#numbers : utility methods for number objects:
/*
* ======================================================================
* See javadoc API for class org.thymeleaf.expression.Numbers
* ======================================================================
*/

/*
* ==========================
* Formatting integer numbers
* ==========================
*/

/*
* Set minimum integer digits.
* Also works with arrays, lists or sets
*/
${#numbers.formatInteger(num,3)}
${#numbers.arrayFormatInteger(numArray,3)}
${#numbers.listFormatInteger(numList,3)}
${#numbers.setFormatInteger(numSet,3)}


/*
* Set minimum integer digits and thousands separator:
* 'POINT', 'COMMA', 'NONE' or 'DEFAULT' (by locale).
* Also works with arrays, lists or sets
*/
${#numbers.formatInteger(num,3,'POINT')}
${#numbers.arrayFormatInteger(numArray,3,'POINT')}
${#numbers.listFormatInteger(numList,3,'POINT')}
${#numbers.setFormatInteger(numSet,3,'POINT')}


/*
* ==========================
* Formatting decimal numbers
* ==========================
*/

/*
* Set minimum integer digits and (exact) decimal digits.
* Also works with arrays, lists or sets
*/
${#numbers.formatDecimal(num,3,2)}
${#numbers.arrayFormatDecimal(numArray,3,2)}
${#numbers.listFormatDecimal(numList,3,2)}
${#numbers.setFormatDecimal(numSet,3,2)}

/*
* Set minimum integer digits and (exact) decimal digits, and also decimal separator.
* Also works with arrays, lists or sets
*/
${#numbers.formatDecimal(num,3,2,'COMMA')}
${#numbers.arrayFormatDecimal(numArray,3,2,'COMMA')}
${#numbers.listFormatDecimal(numList,3,2,'COMMA')}
${#numbers.setFormatDecimal(numSet,3,2,'COMMA')}

/*
* Set minimum integer digits and (exact) decimal digits, and also thousands and
* decimal separator.
* Also works with arrays, lists or sets
*/
${#numbers.formatDecimal(num,3,'POINT',2,'COMMA')}
${#numbers.arrayFormatDecimal(numArray,3,'POINT',2,'COMMA')}
${#numbers.listFormatDecimal(numList,3,'POINT',2,'COMMA')}
${#numbers.setFormatDecimal(numSet,3,'POINT',2,'COMMA')}



/*
* ==========================
* Utility methods
* ==========================
*/

/*
* Create a sequence (array) of integer numbers going
* from x to y
*/
${#numbers.sequence(from,to)}
${#numbers.sequence(from,to,step)}
Strings

#strings : utility methods for String objects:
/*
* ======================================================================
* See javadoc API for class org.thymeleaf.expression.Strings
* ======================================================================
*/

/*
* Check whether a String is empty (or null). Performs a trim() operation before check
* Also works with arrays, lists or sets
*/
${#strings.isEmpty(name)}
${#strings.arrayIsEmpty(nameArr)}
${#strings.listIsEmpty(nameList)}
${#strings.setIsEmpty(nameSet)}

/*
* Perform an 'isEmpty()' check on a string and return it if false, defaulting to
* another specified string if true.
* Also works with arrays, lists or sets
*/
${#strings.defaultString(text,default)}
${#strings.arrayDefaultString(textArr,default)}
${#strings.listDefaultString(textList,default)}
${#strings.setDefaultString(textSet,default)}

/*
* Check whether a fragment is contained in a String
* Also works with arrays, lists or sets
*/
${#strings.contains(name,'ez')}                     // also array*, list* and set*
${#strings.containsIgnoreCase(name,'ez')}           // also array*, list* and set*

/*
* Check whether a String starts or ends with a fragment
* Also works with arrays, lists or sets
*/
${#strings.startsWith(name,'Don')}                  // also array*, list* and set*
${#strings.endsWith(name,endingFragment)}           // also array*, list* and set*

/*
* Substring-related operations
* Also works with arrays, lists or sets
*/
${#strings.indexOf(name,frag)}                      // also array*, list* and set*
${#strings.substring(name,3,5)}                     // also array*, list* and set*
${#strings.substringAfter(name,prefix)}             // also array*, list* and set*
${#strings.substringBefore(name,suffix)}            // also array*, list* and set*
${#strings.replace(name,'las','ler')}               // also array*, list* and set*

/*
* Append and prepend
* Also works with arrays, lists or sets
*/
${#strings.prepend(str,prefix)}                     // also array*, list* and set*
${#strings.append(str,suffix)}                      // also array*, list* and set*

/*
* Change case
* Also works with arrays, lists or sets
*/
${#strings.toUpperCase(name)}                       // also array*, list* and set*
${#strings.toLowerCase(name)}                       // also array*, list* and set*

/*
* Split and join
*/
${#strings.arrayJoin(namesArray,',')}
${#strings.listJoin(namesList,',')}
${#strings.setJoin(namesSet,',')}
${#strings.arraySplit(namesStr,',')}                // returns String[]
${#strings.listSplit(namesStr,',')}                 // returns List<String>
    ${#strings.setSplit(namesStr,',')}                  // returns Set<String>

    /*
    * Trim
    * Also works with arrays, lists or sets
    */
    ${#strings.trim(str)}                               // also array*, list* and set*

    /*
    * Compute length
    * Also works with arrays, lists or sets
    */
    ${#strings.length(str)}                             // also array*, list* and set*

    /*
    * Abbreviate text making it have a maximum size of n. If text is bigger, it
    * will be clipped and finished in "..."
    * Also works with arrays, lists or sets
    */
    ${#strings.abbreviate(str,10)}                      // also array*, list* and set*

    /*
    * Convert the first character to upper-case (and vice-versa)
    */
    ${#strings.capitalize(str)}                         // also array*, list* and set*
    ${#strings.unCapitalize(str)}                       // also array*, list* and set*

    /*
    * Convert the first character of every word to upper-case
    */
    ${#strings.capitalizeWords(str)}                    // also array*, list* and set*
    ${#strings.capitalizeWords(str,delimiters)}         // also array*, list* and set*

    /*
    * Escape the string
    */
    ${#strings.escapeXml(str)}                          // also array*, list* and set*
    ${#strings.escapeJava(str)}                         // also array*, list* and set*
    ${#strings.escapeJavaScript(str)}                   // also array*, list* and set*
    ${#strings.unescapeJava(str)}                       // also array*, list* and set*
    ${#strings.unescapeJavaScript(str)}                 // also array*, list* and set*

    /*
    * Null-safe comparison and concatenation
    */
    ${#strings.equals(str)}
    ${#strings.equalsIgnoreCase(str)}
    ${#strings.concat(str)}
    ${#strings.concatReplaceNulls(str)}

    /*
    * Random
    */
    ${#strings.randomAlphanumeric(count)}
    Objects

    #objects : utility methods for objects in general
    /*
    * ======================================================================
    * See javadoc API for class org.thymeleaf.expression.Objects
    * ======================================================================
    */

    /*
    * Return obj if it is not null, and default otherwise
    * Also works with arrays, lists or sets
    */
    ${#objects.nullSafe(obj,default)}
    ${#objects.arrayNullSafe(objArray,default)}
    ${#objects.listNullSafe(objList,default)}
    ${#objects.setNullSafe(objSet,default)}
    Booleans

    #bools : utility methods for boolean evaluation
    /*
    * ======================================================================
    * See javadoc API for class org.thymeleaf.expression.Bools
    * ======================================================================
    */

    /*
    * Evaluate a condition in the same way that it would be evaluated in a th:if tag
    * (see conditional evaluation chapter afterwards).
    * Also works with arrays, lists or sets
    */
    ${#bools.isTrue(obj)}
    ${#bools.arrayIsTrue(objArray)}
    ${#bools.listIsTrue(objList)}
    ${#bools.setIsTrue(objSet)}

    /*
    * Evaluate with negation
    * Also works with arrays, lists or sets
    */
    ${#bools.isFalse(cond)}
    ${#bools.arrayIsFalse(condArray)}
    ${#bools.listIsFalse(condList)}
    ${#bools.setIsFalse(condSet)}

    /*
    * Evaluate and apply AND operator
    * Receive an array, a list or a set as parameter
    */
    ${#bools.arrayAnd(condArray)}
    ${#bools.listAnd(condList)}
    ${#bools.setAnd(condSet)}

    /*
    * Evaluate and apply OR operator
    * Receive an array, a list or a set as parameter
    */
    ${#bools.arrayOr(condArray)}
    ${#bools.listOr(condList)}
    ${#bools.setOr(condSet)}
    Arrays

    #arrays : utility methods for arrays
    /*
    * ======================================================================
    * See javadoc API for class org.thymeleaf.expression.Arrays
    * ======================================================================
    */

    /*
    * Converts to array, trying to infer array component class.
    * Note that if resulting array is empty, or if the elements
    * of the target object are not all of the same class,
    * this method will return Object[].
    */
    ${#arrays.toArray(object)}

    /*
    * Convert to arrays of the specified component class.
    */
    ${#arrays.toStringArray(object)}
    ${#arrays.toIntegerArray(object)}
    ${#arrays.toLongArray(object)}
    ${#arrays.toDoubleArray(object)}
    ${#arrays.toFloatArray(object)}
    ${#arrays.toBooleanArray(object)}

    /*
    * Compute length
    */
    ${#arrays.length(array)}

    /*
    * Check whether array is empty
    */
    ${#arrays.isEmpty(array)}

    /*
    * Check if element or elements are contained in array
    */
    ${#arrays.contains(array, element)}
    ${#arrays.containsAll(array, elements)}
    Lists

    #lists : utility methods for lists
    /*
    * ======================================================================
    * See javadoc API for class org.thymeleaf.expression.Lists
    * ======================================================================
    */

    /*
    * Converts to list
    */
    ${#lists.toList(object)}

    /*
    * Compute size
    */
    ${#lists.size(list)}

    /*
    * Check whether list is empty
    */
    ${#lists.isEmpty(list)}

    /*
    * Check if element or elements are contained in list
    */
    ${#lists.contains(list, element)}
    ${#lists.containsAll(list, elements)}

    /*
    * Sort a copy of the given list. The members of the list must implement
    * comparable or you must define a comparator.
    */
    ${#lists.sort(list)}
    ${#lists.sort(list, comparator)}
    Sets

    #sets : utility methods for sets
    /*
    * ======================================================================
    * See javadoc API for class org.thymeleaf.expression.Sets
    * ======================================================================
    */

    /*
    * Converts to set
    */
    ${#sets.toSet(object)}

    /*
    * Compute size
    */
    ${#sets.size(set)}

    /*
    * Check whether set is empty
    */
    ${#sets.isEmpty(set)}

    /*
    * Check if element or elements are contained in set
    */
    ${#sets.contains(set, element)}
    ${#sets.containsAll(set, elements)}
    Maps

    #maps : utility methods for maps
    /*
    * ======================================================================
    * See javadoc API for class org.thymeleaf.expression.Maps
    * ======================================================================
    */

    /*
    * Compute size
    */
    ${#maps.size(map)}

    /*
    * Check whether map is empty
    */
    ${#maps.isEmpty(map)}

    /*
    * Check if key/s or value/s are contained in maps
    */
    ${#maps.containsKey(map, key)}
    ${#maps.containsAllKeys(map, keys)}
    ${#maps.containsValue(map, value)}
    ${#maps.containsAllValues(map, value)}
    Aggregates

    #aggregates : utility methods for creating aggregates on arrays or collections
    /*
    * ======================================================================
    * See javadoc API for class org.thymeleaf.expression.Aggregates
    * ======================================================================
    */

    /*
    * Compute sum. Returns null if array or collection is empty
    */
    ${#aggregates.sum(array)}
    ${#aggregates.sum(collection)}

    /*
    * Compute average. Returns null if array or collection is empty
    */
    ${#aggregates.avg(array)}
    ${#aggregates.avg(collection)}
    Messages

    #messages : utility methods for obtaining externalized messages inside variables expressions, in the same way as they would be obtained using #{...} syntax.
    /*
    * ======================================================================
    * See javadoc API for class org.thymeleaf.expression.Messages
    * ======================================================================
    */

    /*
    * Obtain externalized messages. Can receive a single key, a key plus arguments,
    * or an array/list/set of keys (in which case it will return an array/list/set of
    * externalized messages).
    * If a message is not found, a default message (like '??msgKey??') is returned.
    */
    ${#messages.msg('msgKey')}
    ${#messages.msg('msgKey', param1)}
    ${#messages.msg('msgKey', param1, param2)}
    ${#messages.msg('msgKey', param1, param2, param3)}
    ${#messages.msgWithParams('msgKey', new Object[] {param1, param2, param3, param4})}
    ${#messages.arrayMsg(messageKeyArray)}
    ${#messages.listMsg(messageKeyList)}
    ${#messages.setMsg(messageKeySet)}

    /*
    * Obtain externalized messages or null. Null is returned instead of a default
    * message if a message for the specified key is not found.
    */
    ${#messages.msgOrNull('msgKey')}
    ${#messages.msgOrNull('msgKey', param1)}
    ${#messages.msgOrNull('msgKey', param1, param2)}
    ${#messages.msgOrNull('msgKey', param1, param2, param3)}
    ${#messages.msgOrNullWithParams('msgKey', new Object[] {param1, param2, param3, param4})}
    ${#messages.arrayMsgOrNull(messageKeyArray)}
    ${#messages.listMsgOrNull(messageKeyList)}
    ${#messages.setMsgOrNull(messageKeySet)}
    IDs

    #ids : utility methods for dealing with id attributes that might be repeated (for example, as a result of an iteration).
    /*
    * ======================================================================
    * See javadoc API for class org.thymeleaf.expression.Ids
    * ======================================================================
    */

    /*
    * Normally used in th:id attributes, for appending a counter to the id attribute value
    * so that it remains unique even when involved in an iteration process.
    */
    ${#ids.seq('someId')}

    /*
    * Normally used in th:for attributes in <label> tags, so that these labels can refer to Ids
    * generated by means if the #ids.seq(...) function.
    *
    * Depending on whether the <label> goes before or after the element with the #ids.seq(...)
        * function, the "next" (label goes before "seq") or the "prev" function (label goes after
        * "seq") function should be called.
        */
        ${#ids.next('someId')}
        ${#ids.prev('someId')}

        Request

        <p th:text="${#httpServletRequest.getParameter('q')}" >Test</p>

        Session

        <div th:text="${session.xx}">[...]</div>
```

### 推荐阅读

<https://juejin.im/post/5b8fc1fc5188255c34060d5d>

<https://juejin.im/post/5c271fbde51d451b1c6ded58#heading-2>

<https://www.cnblogs.com/ityouknow/p/5833560.html>

<https://www.jianshu.com/p/f79a98173677>