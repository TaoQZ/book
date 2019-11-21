# 网站快速成型工具

​	Element，一套为开发者、设计师和产品经理准备的基于 Vue 2.0 的桌面端组件库



## vue中使用

### 	安装与配置

```javascript
// 安装
npm i element-ui

// 配置
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
Vue.use(ElementUI);
```



## 使用样例

### NavMenu导航菜单

​	 default-active="2" : 默认打开菜单的index

​	 设置为根据路由显示:

​		:default-active="$route.path" 

​		同时在相同位置添加 :router="true"

```javascript
  <el-menu
      :default-active="$route.path"
      class="el-menu-vertical-demo"
      background-color="#545c64"
      text-color="#fff"
      :router="true"
      active-text-color="#ffd04b">
           <el-submenu index="1">
              <template slot="title">
                <i class="el-icon-location"></i>
                <span>首页</span>
              </template>
              <el-menu-item-group>
                <el-menu-item index="路由路径">xxx</el-menu-item>
              </el-menu-item-group>
            </el-submenu>
   </el-menu>    
```



### Table表格

​	获取当前行数据

```javascript
<template slot-scope="scope">
 	{ {scope.row} }
</template>
```



### Pagination 分页

```javascript
<el-pagination
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
                :current-page="页数"
                :page-sizes="[1, 2, 3, 4]"
                :page-size="每页条数"
                layout="total, sizes, prev, pager, next, jumper"
                :total="总条数">
</el-pagination>
```



### Radio单选框

​	需要设置`v-model`绑定变量，选中意味着变量的值为相应 Radio `label`属性的值，`label`可以是`String`、`Number`或`Boolean`

```javascript
 <el-radio v-model="value" :label="0">禁用</el-radio>
```



### Checkbox 多选框

​	注意 :label绑定对应id

​		 value此时对应的应该是一个数字类型的数字

```javascript
<el-checkbox-group v-model="value">
    <el-checkbox v-for="" :key=""  :label=""></el-checkbox>
</el-checkbox-group>
```



### Tree 树形

```javascript
 <el-tree
     :data="数据"
     show-checkbox
     node-key="id" // 指定id为节点的key
     ref="tree"    // 需要添加该属性才能根据key获取
     :props="defaultProps">
 </el-tree>
 
 // 数据格式 对应数据的字段名
  defaultProps: 
      {
     	 children: '',
     	 label: ''
      }
// 获取值
// 全选
   this.$refs.tree.getCheckedKeys()+''
// 半选 也就是父级
// this.$refs.tree.getHalfCheckedKeys()

```



### Tabs 标签页

​	标签

```h
  <el-tabs v-model="activename"  closable @tab-click="handleClick" @tab-remove="removeTab">
<!--          title 是路由的名称也就是tab的title   -->
<!--          path  是路由的path也就是tab的path  -->
<!--          activename 绑定的是path  -->
<!--          tabs 所有的选项卡  -->
    <el-tab-pane
        v-for="(item, index) in tabs"
        :key="index"
        :label="item.title"
        :name="item.path">
    </el-tab-pane>
</el-tabs>



```

​	js

```javascript
<script>
export default {
  name: 'home',
   data(){
       return{
          activename:'/home',
          tabs:[]
       }
   },
  methods:{
    // 点击选项卡后触发的方法
    handleClick(tab, event) {
      // 跳转到对应选项卡的path
      this.$router.push(tab.name)
    },
      // 添加选项卡
    addTab(routeName,routePath){
        // 如果是首页 不添加直接返回
        if (routeName == 'home'){
          return
        }
        // 设置标记 用来标记选项卡数组中是否已存在要添加的
        // 如果存在 则选中该选项卡
        let flag = true;
        this.tabs.forEach(ele => {
          if (ele.title == routeName){
            flag = false;
            this.activename = ele.path
          }
        })

        // 添加选项卡
        // title 使用路由的名称
        // path 使用路由的path
        if (flag){
          this.tabs.push({
            title: routeName,
            path: routePath
          })
            // 将新添加的选项卡激活
          this.activename = routePath
        }

    },
      // 移除选项卡
    removeTab(targetName){

        this.tabs.forEach((ele,index) => {
          if (ele.path == targetName){
            this.tabs.splice(index,1)
          }
        })
        // 如果选项卡组中还有其他选项卡,将最后一个激活 否则跳转首页
      if (this.tabs.length != 0){
        this.activename = this.tabs[this.tabs.length-1].path
        this.$router.push(this.tabs[this.tabs.length-1].path)
      }else {
          this.$router.push('/home')
      }

    }
  },
    // 监听路由 发生变化时添加选项卡
  watch:{
    '$route'(to,from){
        this.addTab(to.name,to.path)
    }
  },
    // 页面激活添加选项卡
  mounted() {
    this.addTab(this.$route.name,this.$route.path)
  }

}
</script>
```



###  DatePicker 日期选择器

```html
<el-date-picker
        v-model="绑定属性"
        type="date"
        value-format="yyyy-MM-dd" // 设置格式
        placeholder="选择日期">
</el-date-picker>
```



### Cascader级联选择器

```java
 <el-cascader
     v-model="values"
     :options="数据"
     :props="props" // 指定数据格式 
     @change="handleChange"> // 改变时触发的方法
 </el-cascader>

data(){
    return{
    	values:[],
        props:{
        	// 最后获取的是该value值
            value:'',
            label:'',
            children:''
        }
    }
},
method:{
     handleChange(value) {
    	 console.log(value);
     },
}

```

























