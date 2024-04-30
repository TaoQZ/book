解决element-ui在展示数据时会少显示一个空格的问题

解决方案:将空格替换为 

```
&nbsp;
{{scope.row.chinese.replace(/ /g, '&nbsp;')}}
```

