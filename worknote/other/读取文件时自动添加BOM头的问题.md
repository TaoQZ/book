Java读取Unicode文件时碰到的BOM首字符问题,及处理方法

https://blog.csdn.net/ClementAD/article/details/47168573

在windows下用文本编辑器创建的文本文件,如果用UTF-8等 Unicode格式保存,会在文件头,第一个字符加入一个BOM标识

在Java读取文件时,不会被去掉,String.trim()也无法删除

Java在读取Unicode文件时会统一把BOM变成**\uFEFF**,可以手动解决

```java
number = number.trim().replaceAll("\uFEFF","");
```

**什么是BOM？**

BOM = Byte Order Mark

BOM是Unicode规范中推荐的标记字节顺序的方法。比如说对于UTF-16，如果接收者收到的BOM是FEFF，表明这个字节流是Big-Endian的；如果收到FFFE，就表明这个字节流是Little-Endian的。

UTF-8不需要BOM来表明字节顺序，但可以用BOM来表明“我是UTF-8编码”。BOM的UTF-8编码是EF BB BF（用UltraEdit打开文本、切换到16进制可以看到）。所以如果接收者收到以EF BB BF开头的字节流，就知道这是UTF-8编码了。