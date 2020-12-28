mysql日期函数

## 12.5. 日期和时间函数

本章论述了一些可用于操作时间值的函数。关于每个时间和日期类型具有的值域及指定值的有效格式，请参见[11.3节，“日期和时间类型”](mk:@MSITStore:D:\5.API\MySQL_5.1_zh.chm::/column-types.html#date-and-time-types)。

下面的例子使用了时间函数。以下询问选择了最近的 30天内所有带有date_col 值的记录：

mysql> **SELECT \*something\* FROM \*tbl_name\***

  -> **WHERE DATE_SUB(CURDATE(),INTERVAL 30 DAY) <= \*date_col\*;**

注意，这个询问也能选择将来的日期记录。 以下是其他日期函数使用说明

### l ADDDATE(date,INTERVAL expr type) ADDDATE(expr,days) 

当被第二个参数的INTERVAL格式激活后， ADDDATE()就是DATE_ADD()的同义词。相关函数SUBDATE() 则是DATE_SUB()的同义词。对于INTERVAL参数上的信息 ，请参见关于DATE_ADD()的论述。 

mysql> **SELECT DATE_ADD('1998-01-02', INTERVAL 31 DAY);**

​    -> '1998-02-02'

mysql> **SELECT ADDDATE('1998-01-02', INTERVAL 31 DAY);**

​    -> '1998-02-02'

若 *days* 参数只是整数值，则 MySQL 5.1将其作为天数值添加至 *expr*。 

mysql> **SELECT ADDDATE('1998-01-02', 31);**

​    -> '1998-02-02'

### l CURDATE() 

将当前日期按照'YYYY-MM-DD' 或YYYYMMDD 格式的值返回，具体格式根据函数用在字符串或是数字语境中而定。

mysql> **SELECT CURDATE();**

​    -> '1997-12-15'

mysql> **SELECT CURDATE() + 0;**

​    -> 19971215

### l CURTIME() 

将当前时间以'HH:MM:SS'或 HHMMSS 的格式返回， 具体格式根据函数用在字符串或是数字语境中而定。 

mysql> **SELECT CURTIME();**

​    -> '23:50:26'

### l DATE(expr) 

提取日期或时间日期表达式*expr*中的日期部分。 

mysql> **SELECT DATE('2003-12-31 01:02:03');**

​    -> '2003-12-31'

### l DATEDIFF(expr,expr2) 

DATEDIFF() 返回起始时间 *expr*和结束时间*expr2*之间的天数。*Expr*和*expr2* 为日期或 date-and-time 表达式。计算中只用到这些值的日期部分。

mysql> **SELECT DATEDIFF('1997-12-31 23:59:59','1997-12-30');**

​    -> 1

mysql> **SELECT DATEDIFF('1997-11-30 23:59:59','1997-12-31');**

​    -> -31

### l DATE_ADD(date,INTERVAL expr type) DATE_SUB(date,INTERVAL expr type) 

这些函数执行日期运算。 *date* 是一个 DATETIME 或DATE值，用来指定起始时间。 *expr* 是一个表达式，用来指定从起始日期添加或减去的时间间隔值。 *Expr*是一个字符串;对于负值的时间间隔，它可以以一个 ‘-’开头。 *type* 为关键词，它指示了表达式被解释的方式。 

关键词INTERVA及 *type* 分类符均不区分大小写。 

以下表显示了*type* 和*expr* 参数的关系： 

| *type* **值**      | **预期的** *expr* **格式**    |
| ------------------ | ----------------------------- |
| MICROSECOND        | MICROSECONDS                  |
| SECOND             | SECONDS                       |
| MINUTE             | MINUTES                       |
| HOUR               | HOURS                         |
| DAY                | DAYS                          |
| WEEK               | WEEKS                         |
| MONTH              | MONTHS                        |
| QUARTER            | QUARTERS                      |
| YEAR               | YEARS                         |
| SECOND_MICROSECOND | 'SECONDS.MICROSECONDS'        |
| MINUTE_MICROSECOND | 'MINUTES.MICROSECONDS'        |
| MINUTE_SECOND      | 'MINUTES:SECONDS'             |
| HOUR_MICROSECOND   | 'HOURS.MICROSECONDS'          |
| HOUR_SECOND        | 'HOURS:MINUTES:SECONDS'       |
| HOUR_MINUTE        | 'HOURS:MINUTES'               |
| DAY_MICROSECOND    | 'DAYS.MICROSECONDS'           |
| DAY_SECOND         | 'DAYS  HOURS:MINUTES:SECONDS' |
| DAY_MINUTE         | 'DAYS HOURS:MINUTES'          |
| DAY_HOUR           | 'DAYS HOURS'                  |
| YEAR_MONTH         | 'YEARS-MONTHS'                |

MySQL 允许任何*expr* 格式中的标点分隔符。表中所显示的是建议的 分隔符。若 *date* 参数是一个 DATE 值，而你的计算只会包括 YEAR、MONTH和DAY部分(即, 没有时间部分), 其结果是一个DATE 值。否则，结果将是一个 DATETIME值。

若位于另一端的表达式是一个日期或日期时间值 ， 则INTERVAL *expr* *type*只允许在 + 操作符的两端。对于 –操作符， INTERVAL *expr* *type* 只允许在其右端，原因是从一个时间间隔中提取一个日期或日期时间值是毫无意义的。 (见下面的例子）。 

mysql> **SELECT DATE_ADD('1997-12-31 23:59:59',**

  ->         **INTERVAL 1 SECOND);**

​    -> '1998-01-01 00:00:00'

mysql> **SELECT DATE_ADD('1997-12-31 23:59:59',**

  ->         **INTERVAL 1 DAY);**

​    -> '1998-01-01 23:59:59'

mysql> **SELECT DATE_ADD('1997-12-31 23:59:59',**

  ->         **INTERVAL '1:1' MINUTE_SECOND);**

​    -> '1998-01-01 00:01:00'

mysql> **SELECT DATE_SUB('1998-01-01 00:00:00',**

  ->         **INTERVAL '1 1:1:1' DAY_SECOND);**

​    -> '1997-12-30 22:58:59'

mysql> **SELECT DATE_ADD('1998-01-01 00:00:00',**

  ->         **INTERVAL '-1 10' DAY_HOUR);**

​    -> '1997-12-30 14:00:00'

mysql> **SELECT DATE_SUB('1998-01-02', INTERVAL 31 DAY);**

​    -> '1997-12-02'

mysql> **SELECT DATE_ADD('1992-12-31 23:59:59.000002',**

  ->      **INTERVAL '1.999999' SECOND_MICROSECOND);**

​    -> '1993-01-01 00:00:01.000001'

若你指定了一个过于短的时间间隔值 (不包括*type* 关键词所预期的所有时间间隔部分), MySQL 假定你已经省去了时间间隔值的最左部分。 例如，你指定了一种类型的DAY_SECOND, *expr* 的值预期应当具有天、 小时、分钟和秒部分。若你指定了一个类似 '1:10'的值, MySQL 假定天和小时部分不存在，那么这个值代表分和秒。换言之, '1:10' DAY_SECOND 被解释为相当于 '1:10' MINUTE_SECOND。这相当于 MySQL将TIME 值解释为所耗费的时间而不是日时的解释方式。       

假如你对一个日期值添加或减去一些含有时间部分的内容，则结果自动转化为一个日期时间值：

mysql> **SELECT DATE_ADD('1999-01-01', INTERVAL 1 DAY);**

​    -> '1999-01-02'

mysql> **SELECT DATE_ADD('1999-01-01', INTERVAL 1 HOUR);**

​    -> '1999-01-01 01:00:00'

假如你使用了格式严重错误的日期,则结果为 NULL。假如你添加了 MONTH、YEAR_MONTH或YEAR ，而结果日期中有一天的日期大于添加的月份的日期最大限度，则这个日期自动被调整为添加月份的最大日期：

mysql> **SELECT DATE_ADD('1998-01-30', INTERVAL 1 MONTH);**

​    -> '1998-02-28'

### l DATE_FORMAT(date,format) 

根据*format* 字符串安排*date* 值的格式。 

以下说明符可用在 *format* 字符串中：

| **说明符** | **说明**                                                     |
| ---------- | ------------------------------------------------------------ |
| %a         | 工作日的缩写名称 (Sun..Sat)                                  |
| %b         | 月份的缩写名称 (Jan..Dec)                                    |
| %c         | 月份，数字形式(0..12)                                        |
| %D         | 带有英语后缀的该月日期 (0th, 1st, 2nd, 3rd, ...)             |
| %d         | 该月日期, 数字形式 (00..31)                                  |
| %e         | 该月日期, 数字形式(0..31)                                    |
| %f         | 微秒 (000000..999999)                                        |
| %H         | 小时(00..23)                                                 |
| %h         | 小时(01..12)                                                 |
| %I         | 小时 (01..12)                                                |
| %i         | 分钟,数字形式 (00..59)                                       |
| %j         | 一年中的天数 (001..366)                                      |
| %k         | 小时 (0..23)                                                 |
| %l         | 小时 (1..12)                                                 |
| %M         | 月份名称 (January..December)                                 |
| %m         | 月份, 数字形式 (00..12)                                      |
| %p         | 上午（AM）或下午（ PM）                                      |
| %r         | 时间 , 12小时制 (小时hh:分钟mm:秒数ss 后加 AM或PM)           |
| %S         | 秒 (00..59)                                                  |
| %s         | 秒 (00..59)                                                  |
| %T         | 时间 , 24小时制 (小时hh:分钟mm:秒数ss)                       |
| %U         | 周 (00..53), 其中周日为每周的第一天                          |
| %u         | 周 (00..53), 其中周一为每周的第一天                          |
| %V         | 周 (01..53), 其中周日为每周的第一天 ; 和 %X同时使用          |
| %v         | 周 (01..53), 其中周一为每周的第一天 ; 和 %x同时使用          |
| %W         | 工作日名称 (周日..周六)                                      |
| %w         | 一周中的每日 (0=周日..6=周六)                                |
| %X         | 该周的年份，其中周日为每周的第一天, 数字形式,4位数;和%V同时使用 |
| %x         | 该周的年份，其中周一为每周的第一天, 数字形式,4位数;和%v同时使用 |
|            | 年份, 数字形式,4位数                                         |
| %y         | 年份, 数字形式 (2位数)                                       |
| %%         | ‘%’文字字符                                                  |

所有其它字符都被复制到结果中，无%Y需作出解释。

注意， ‘%’字符要求在格式指定符之前。

月份和日期说明符的范围从零开始，原因是 MySQL允许存储诸如 '2004-00-00'的不完全日期. 

```
mysql> SELECT DATE_FORMAT('1997-10-04 22:23:00', '%W %M %Y');
        -> 'Saturday October 1997'
mysql> SELECT DATE_FORMAT('1997-10-04 22:23:00', '%H:%i:%s');
        -> '22:23:00'
mysql> SELECT DATE_FORMAT('1997-10-04 22:23:00',
                          '%D %y %a %d %m %b %j');
        -> '4th 97 Sat 04 10 Oct 277'
mysql> SELECT DATE_FORMAT('1997-10-04 22:23:00',
                          '%H %k %I %r %T %S %w');
        -> '22 22 10 10:23:00 PM 22:23:00 00 6'
mysql> SELECT DATE_FORMAT('1999-01-01', '%X %V');
        -> '1998 52'
```

### l DAY(date) 

DAY() 和DAYOFMONTH()的意义相同。

### l DAYNAME(date) 

返回*date* 对应的工作日名称。

mysql> **SELECT DAYNAME('1998-02-05');**

​    -> '周四'

### l DAYOFMONTH(date) 

返回*date* 对应的该月日期，范围是从 1到31。

mysql> **SELECT DAYOFMONTH('1998-02-03');**

​    -> 3

### l DAYOFWEEK(date) 

返回*date* (1 = 周日, 2 = 周一, ..., 7 = 周六)对应的工作日索引。这些索引值符合 ODBC标准。

mysql> **SELECT DAYOFWEEK('1998-02-03');**

​    -> 3

### l DAYOFYEAR(date) 

返回*date* 对应的一年中的天数，范围是从 1到366。

mysql> **SELECT DAYOFYEAR('1998-02-03');**

​    -> 34

### l FROM_DAYS(N) 

给定一个天数 *N*, 返回一个DATE值。

mysql> **SELECT FROM_DAYS(729669);**

​    -> '1997-10-07'

使用 FROM_DAYS()处理古老日期时，务必谨慎。他不用于处理阳历出现前的日期(1582)。请参见[12.6节，“MySQL使用什么日历？”](mk:@MSITStore:D:\5.API\MySQL_5.1_zh.chm::/functions.html#mysql-calendar)。

### l HOUR(time) 

返回*time* 对应的小时数。对于日时值的返回值范围是从 0 到 23 。

mysql> **SELECT HOUR('10:05:03');**

​    -> 10

然而, TIME 值的范围实际上非常大, 所以HOUR可以返回大于23的值。

mysql> **SELECT HOUR('272:59:59');**

​    -> 272

### l LAST_DAY(date) 

获取一个日期或日期时间值，返回该月最后一天对应的值。若参数无效，则返回NULL。

mysql> **SELECT LAST_DAY('2003-02-05');**

​    -> '2003-02-28'

mysql> **SELECT LAST_DAY('2004-02-05');**

​    -> '2004-02-29'

mysql> **SELECT LAST_DAY('2004-01-01 01:01:01');**

​    -> '2004-01-31'

mysql> **SELECT LAST_DAY('2003-03-32');**

​    -> NULL

### l MINUTE(time) 

返回 *time* 对应的分钟数,范围是从 0 到 59。

mysql> **SELECT MINUTE('98-02-03 10:05:03');**

​    -> 5

### l MONTH(date) 

返回*date* 对应的月份，范围时从 1 到 12。

mysql> **SELECT MONTH('1998-02-03');**

​    -> 2

### l NOW() 

返回当前日期和时间值，其格式为 'YYYY-MM-DD HH:MM:SS' 或YYYYMMDDHHMMSS ， 具体格式取决于该函数是否用在字符串中或数字语境中。 

mysql> **SELECT NOW();**

​    -> '1997-12-15 23:50:26'

mysql> **SELECT NOW() + 0;**

​    -> 19971215235026

在一个存储程序或触发器内, NOW() 返回一个常数时间，该常数指示了该程序或触发语句开始执行的时间。这同SYSDATE()的运行有所不同。

### l WEEK(date[,mode]) 

该函数返回*date* 对应的星期数。WEEK() 的双参数形式允许你指定该星期是否起始于周日或周一， 以及返回值的范围是否为从0 到53 或从1 到53。若 *mode*参数被省略，则使用default_week_format系统自变量的值。请参见[5.3.3节，“服务器系统变量”](mk:@MSITStore:D:\5.API\MySQL_5.1_zh.chm::/database-administration.html#server-system-variables)。

以下表说明了*mode* 参数的工作过程：d 

|          | **第一天** |          |                             |
| -------- | ---------- | -------- | --------------------------- |
| **Mode** | **工作日** | **范围** | **Week 1** **为第一周 ...** |
| 0        | 周日       | 0-53     | 本年度中有一个周日          |
| 1        | 周一       | 0-53     | 本年度中有3天以上           |
| 2        | 周日       | 1-53     | 本年度中有一个周日          |
| 3        | 周一       | 1-53     | 本年度中有3天以上           |
| 4        | 周日       | 0-53     | 本年度中有3天以上           |
| 5        | 周一       | 0-53     | 本年度中有一个周一          |
| 6        | 周日       | 1-53     | 本年度中有3天以上           |
| 7        | 周一       | 1-53     | 本年度中有一个周一          |

mysql> **SELECT WEEK('1998-02-20');**

​    -> 7

mysql> **SELECT WEEK('1998-02-20',0);**

​    -> 7

mysql> **SELECT WEEK('1998-02-20',1);**

​    -> 8

mysql> **SELECT WEEK('1998-12-31',1);**

​    -> 53

注意，假如有一个日期位于前一年的最后一周， 若你不使用2、3、6或7作为*mode* 参数选择，则MySQL返回 0：

mysql> **SELECT YEAR('2000-01-01'), WEEK('2000-01-01',0);**

​    -> 2000, 0

有人或许会提出意见，认为 MySQL 对于WEEK() 函数应该返回 52 ，原因是给定的日期实际上发生在1999年的第52周。我们决定返回0作为代替的原因是我们希望该函数能返回“给定年份的星期数”。这使得WEEK() 函数在同其它从日期中抽取日期部分的函数结合时的使用更加可靠。

假如你更希望所计算的关于年份的结果包括给定日期所在周的第一天，则应使用 0、2、5或 7 作为*mode*参数选择。

mysql> **SELECT WEEK('2000-01-01',2);**

​    -> 52

作为选择，可使用 YEARWEEK()函数: 

mysql> **SELECT YEARWEEK('2000-01-01');**

​    -> 199952

mysql> **SELECT MID(YEARWEEK('2000-01-01'),5,2);**

​    -> '52'

### l YEAR(date) 

返回*date* 对应的年份,范围是从1000到9999。

mysql> **SELECT YEAR('98-02-03');**

​    -> 1998

 