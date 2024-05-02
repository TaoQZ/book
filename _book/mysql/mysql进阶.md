

# 约束

添加表约束的作用,是为了保证表中记录的有效以及完整性

约束分类

实体完整性:数据行约束,主键约束,唯一约束

域完整性:数据类型,默认约束,非空约束

引用完整性:外键约束

## 主键约束

表中的每行数据都应该有可以标识自己唯一的列。假如没有唯一的列或者说主键,更新或删除表中的特定行会很困难,没有安全的办法保证只涉及相关的行

### 主键的规则

primary key

每行都必须具有一个主键值

主键列不能为null,主键值必须唯一

### 添加主键

方式一:在创建表时,在字段后声明指定字段为主键

```
create table person(
    id int primary key ,
    name varchar(5)
)
```

方式二:创建表时,在约束区域,声明指定字段为主键

```
create table person(
    id int  ,
    name varchar(5),
    primary key (id)
)
```

方式三:创建表后,修改表结构,指定字段为主键

```
create table person(
    id int  ,
    name varchar(5)
);
alter table person add primary key (id);
```

删除主键:使用修改表结构的语句删除主键

```
alter table person drop primary key;
```

### 自动增长列

前面说主键的值在每一行都不能重复,从而保障数据的唯一性,如果我们手动去维护这个值将会很困难,也不现实。所以mysql为我们实现了这一点。

自增长列类型必须是整数型,并且一般为主键

添加自增长列

```
create table person(
    id int primary key auto_increment,
    name varchar(5)
);
```

设置自增后,在插入数据时,可以不为该列添加值,或者设置为null值

auto_increment默认从1开始,也可以修改起始值

```
alter table person auto_increment = 100;
```

### 注意事项

不更新主键列的值,不重复用主键列的值,不要使用可能会修改的值作为主键,虽然不是必须,但是尽量遵守

### 联合主键

联合主键也仅是一个主键

在复杂的情况下可以使用多个列作为主键,同样要求其字段值不能为null,而且不能重复(联合主键的多个列的值都相同)

```
create table person(
    id int  ,
    name varchar(5),
    idCard varchar(50),
    primary key (id,name)
);
```



## 非空约束

非空约束not null强制列不接受null值,也就意味着使用非空约束的列始终包含值

```
create table person(
    id int  not null ,
    name varchar(5) not null ,
    idCard varchar(50)
);
```

修改表结构

```
alter table person modify name varchar(5) not null ;
```

删除非空约束

```
alter table person modify name varchar(5);
```

## 唯一约束

unique约束唯一标识数据库表中的每条记录

unique和primary key约束都保证了列值的唯一性,primary key自动拥有unique约束

unique和primary key的区别,每个表中可以有多个唯一约束,但是主键只能有一个,唯一约束允许值为null(多个),而primary key则较为严格不允许值为null

添加唯一约束

方式一

```
create table person(
    id int  ,
    name varchar(5) unique ,
    idCard varchar(50)
);
```

方式二

```
create table person(
    id int  ,
    name varchar(5)  ,
    idCard varchar(50),
    unique (name,idCard)
);
```

方式三

```
alter table person add unique (name);
```



## 默认约束

默认约束的作用是在添加数据时如果不指定值使用默认值

```
create table person(
    id int  ,
    name varchar(5)  default 'zs',
    idCard varchar(50)
);
```

```
alter table person modify name varchar(5) default 'zz';
```

删除默认约束

```
alter table person modify name varchar(5);
```



## 外键约束

根据数据库的三范式中的第二范式,一张表中只能存储一种数据,如果有多种类型的数据需要拆分表

拆分表后需要建立关系,所以就有了外键,又分为主表和从表,在从表中建立外键指向主表的主键,从表外键的数据类型和长度必须和主表中一致

可以进行手动维护外键,不必建立强一致性的外键

### 多表关系

一对多:比如员工表和部门表,一个部门中有多个员工,而一个员工只属于一个部门,此时的部门便是一方,员工便是多方

多对多:比如学生表和课程表,一个学生可以选修多门课程,一门课程下又有多名学生,此时变为多对多的关系,需要建立一张中间表用来存储之前的关系

一对一:使用较少,因为一对一其实也可合成一张表

## 关联查询

两张表一张员工表,一张部门表,员工表中手动维护部门id

```
CREATE TABLE `emp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `dept_id` int(11) DEFAULT NULL,
  `position_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8
```

```
CREATE TABLE `dept` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dept_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8
```

笛卡尔积

也叫交叉连接

```
# 会产生笛卡尔积,将所有的记录全部匹配一遍(也就是两张记录的乘积)
select * from emp,dept;

#符合条件的
select * from emp,dept where emp.dept_id = dept.id;
```

内连接

inner join

```
# 两张表中同时符合条件的记录,才会显示内容
select * from emp,dept where emp.dept_id = dept.id;
# 显示内连接 可以使用where和on进行条件筛选
select * from emp inner join dept where emp.dept_id = dept.id;
select * from emp inner join dept on emp.dept_id = dept.id;
select * from emp  join dept on emp.dept_id = dept.id;
```

外连接

左外连接

left outer join = left join

左连接的结果集包括左表中的所有行,并且如果在匹配条件中左表的某行在右表中没有匹配行,则相关右表的列值都为null

```
# 这条sql语句会报错,不能使用where进行条件过滤
select * from emp  e left join dept d where e.dept_id = d.id;
# 以下两条sql的执行结果是一致的 as name 是为表起别名(当关联查询时,表多的情况下可以选择使用),也可以省略as 关键字和outer关键字
select * from emp as e left outer join dept as d on e.dept_id = d.id;
select * from emp  e left join dept  d on e.dept_id = d.id;
```

右外连接

right outer join = right join

右连接的结果集包括右表中所有的行,并且如果在匹配条件中右表的某行在左表中没有匹配行,则相关左表的列值都为null

```
# 这条sql语句会报错,不能使用where进行条件过滤
select * from emp  e right join  dept d where e.dept_id = d.id;
# 以下两条sql的执行结果是一致的 as name 是为表起别名(当关联查询时,表多的情况下可以选择使用),也可以省略as 关键字和outer关键字
select * from emp as e right outer join dept as d on e.dept_id = d.id;
select * from emp  e right  join dept  d on e.dept_id = d.id;
```

union,union all

将多个select语句的结果组合到一个结果集中

```
# 效果是左连接和右连接的组合
select * from emp left join dept on emp.dept_id = dept.id union all
select * from emp right join dept on emp.dept_id = dept.id;
# 效果是先将两张表进行内连接,然后剩下的结果集分别是两张表中没有匹配的行
# 也就是达到了union all 去重的效果
select * from emp left join dept on emp.dept_id = dept.id union
select * from emp right join dept on emp.dept_id = dept.id;
```

## 备份还原数据库

```
# 备份单个库
mysqldump -uroot -p --databases 数据库名 > d:\pms.sql(文件保存位置)

# 备份整个库
mysqldump -h 127.0.0.1 -P 3306 -u root --default-character-set=gbk -p --all-databases > d:\dumpfile.sql 
```

```
# 还原数据库
mysql -uroot -p yuan < d:\yuan.sql
```

