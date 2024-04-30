mysql中sum函数没统计到任何记录时,会返回null而不是0,可以使用ifnull()函数将null转换为0

mysql中count字段不统计null值所在的列,count(*)才是统计所有记录数量的正确方式

mysql中 = null并不是判断条件而是赋值,对null进行判断只能使用is null 或者is not null