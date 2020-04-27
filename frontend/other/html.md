# HTML

前端三大件:HTML,CSS,JavaScript行为

HTML是CSS的基石

如何理解HTML?

可以把HTML看作是一个文档,元素也就是描述文档的结构,有区块和大纲

## HTML常见元素

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- 页面字符集 -->
    <meta charset="UTF-8">
    <!-- 视口 可适配移动端 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
</head>
<body>
    <!-- 一个区块 -->
    <section>
        <!-- 标题 -->
        <h1>链接</h1>
        <!-- target属性默认为self自身打开 blank:打开一个新的页面 -->
        <a href="https://www.baidu.com">百度</a>
        <a href="https://www.google.com/" target="blank">谷歌</a>
    </section>

    <section>
        <h1>表格</h1>
        <!-- 边框 -->
        <table border="1">
            <!-- 表头 -->
            <thead>
                <tr>
                    <th>表头1</th>
                    <th>表头2</th>
                    <th>表头3</th>
                </tr>
            </thead>
            <!-- 主体 -->
            <tbody>
                <tr>
                    <td>数据1</td>
                    <td>数据2</td>
                    <td>数据3</td>
                </tr>
                <tr>
                    <!-- 跨2列 -->
                    <td colspan="2">数据1</td>
                    <td>数据3</td>
                </tr>
                <tr>
                    <!-- 跨2行 -->
                    <td rowspan="2">数据1</td>
                    <td>数据2</td>
                    <td>数据3</td>
                </tr>
                <tr>
                    <td>数据2</td>
                    <td>数据3</td>
                </tr>
            </tbody>
        </table>
    </section>

    <section>
        <h1>表单</h1>
        <form method="GET" action="http://www.qq.com">
            <p>
                <!-- 下拉框 提交表单时会将name和选中的value进行提交 name=value -->
                <!-- selected 默认选中 -->
                <select name="select1">
                    <option value="1">一</option>
                    <option value="2" selected>二</option>
                </select>
            </p>
            <p>
                <!-- 文本框 输入值不会隐藏 -->
                <input type="text" name="text1" />
            </p>
            <p>
                <!-- 密码框 输入值会进行隐藏 -->
                <input type="password" name="password" />
            </p>
            <p>
                <!-- 多选框 checked 默认选中 -->
                <input type="checkbox" name="checkbox1" value="swim"> 游泳
                <input type="checkbox" checked name="checkbox1" value="run"> 跑步
                <input type="checkbox" name="checkbox1" value="jump"> 跳绳
            </p>
            <p>
                <!-- 单选框 -->
                <input type="radio" name="radio1" id="radio1-1" />
                <label >选项一</label>
                <input type="radio" name="radio1" id="radio1-2" />
                <!-- for会和跟该值相同id的元素进行关联 -->
                <label for="radio1-2">选项二</label>
            </p>
            <p>
                <!-- HTML5新增内容 -->
                <input type="search">搜索
                <input type="time">时间
                <input type="date">日期
            </p>
            <p>
                <!-- 如果不添加任何属性 默认提交表单 -->
                <button type="button">普通按钮</button>
                <button type="submit">提交按钮一</button>
                <input type="submit" value="提交按钮二"/>
                <button type="reset">重置按钮</button>
            </p>
        </form>
    </section>

</body>
</html>
```



## HTML版本

![image-20200314225355865](html.assets/image-20200314225355865.png)

HTML5新增内容,主要为了更加语义化,并且语法没有像XHTML那么严格

比如新区块标签:section article nav aside



## HTML元素分类

这里主要按照样式分



### 块级元素block

大多为大纲元素

设置display:block就是将元素显示为块级元素

```html
常见:<div>、<p>、<h1>...<h6>、<ol>、<ul>、<dl>、<table>、<address>、<blockquote> 、<form>
```

特点

1.每个块级元素都会独占一行

2.元素的高度、宽度、行高以及顶和底边距都可设置

3.元素宽度在不设置的情况下,默认是其父容器的100%



### 内联元素inline

可能不一定有规则的形状,没有尺寸概念 大多为文本元素

块状元素也可以设置display:inline变为行内元素

```
常见:<a>、<span>、<br>、<i>、<em>、<strong>、<label>、<q>、<var>、<cite>、<code>
```

从名字上看就大概知道其特点

1.和其他元素都在一行上

2.元素的高度、宽度、行高及顶部和底部边距不可设置

3.元素的宽度就是它包含的文字或图片的宽度,不可改变



### 内联块状inline-block	

将元素设置为内联块状:display:inline-block

```
常见:<img>、<input>以及表单元素
```

同时具备内联元素、块状元素的特点

1.和其他元素都在一行上

2.元素的高度、宽度、行高以及顶和底边距都可设置



## HTML元素嵌套关系

块级元素可以包含行内元素

块级元素不一定能包含块级元素

行内元素一般不能包含块级元素



## HTML元素默认样式和定制化

 html的元素在浏览器渲染时都有其默认的样式,如果需要统一可以使用CSS Reset进行重置

简便方法,*选取所有元素,将其内外边距都设置为0

```
*{
	margin:0;
	padding:0;
}
```





