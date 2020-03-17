# Vue

##  Vue是什么

​	Vue是一套用于构建用户界面的**渐进式框架**(可以循序渐进的进行学习),是一个**MVVM**的框架,功能强大,重要特点双向绑定

​	MVVM:

​		M:model,数据/模型层

​		V:view 视图层

​		VM:核心层,负责连接M和V,这一层已经由Vue实现好了

​	双向绑定:

​		更新view页面的数据同步到data

​		更新data中的数据同步渲染到页面

## 使用Vue	

​	**以下案例的github地址:https://github.com/TaoQZ/Vue_example.git**

### 	使用cdn	

```html
<!-- 开发环境版本，包含了有帮助的命令行警告 -->
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>

<!-- 生产环境版本，优化了尺寸和速度 -->
<script src="https://cdn.jsdelivr.net/npm/vue"></script>
```

### 	官网下载

```html
https://cn.vuejs.org/v2/guide/installation.html
```



## 入门案例

```vue
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="js/vue-2.6.10.js"></script>
</head>
<body>
<!-- 父容器 要有id属性   -->
<!-- 需要被vue控制写到该容器中   -->
    <div id="app">
        {{msg}}
    </div>

    <script>
        // 创建vue实例
        // el 获取指定id的容器
        // data 数据
        // methods 方法
        var vm = new Vue({
            el:'#app',
            data:{
                msg:'测试'
            },
            methods:{

            }
        })
    </script>
</body>
</html>
```



## 方法

```vue
<script>
        var vm = new Vue({
            methods:{
                fun1:function () {
                    console.log('方法1')
                },
                fun2(){
                    console.log('方法2')
                },
                // 箭头函数
                // 1. 没有参数,或多个参数使用 () (a,b)
                // 2. 一个参数可以省略() 直接写形参 a
                // 3. 返回值 只有一行代码包括返回值 可以省略{}
                // 4. 多行代码需要 {}
                // 5. 注意 使用该箭头函数定义方法时,方法中this的指向不在再是Vue实例
                fun3: () => console.log('方法3')
            }
        });
        vm.fun1();
        vm.fun2();
        vm.fun3();
    </script>
```



## 生命周期

```html
<body>
    <div id="app">
        {{msg}}
<!--     用来更新数据   -->
        <input type="button" value="Button" @click="msg='-'">
    </div>

    <script>
        var vm = new Vue({
            el:'#app',
            data:{
                msg:'+'
            },
            methods:{
                show(){
                    console.log('我是show方法')
                }
            },
            // 初始化前 数据和方法均为未初始化
            beforeCreate(){
                // undefined
                console.log(this.msg)
                // this.show is not a function
                this.show()
                console.log('=======================================')
            },
            // 初始化完成 数据和方法已初始化完成
            created(){
                // 全部正常打印
                console.log(this.msg)
                this.show()
                console.log('=======================================')
            },
            // 双向绑定(挂载)前,表示模板已经编译完成,但是未将模板渲染到页面中
            beforeMount(){
                // {{msg}} 未渲染状态,只是原始字符串
                console.log(document.getElementById('app').innerText)
                console.log('=======================================')
            },
            // 双向绑定(挂载)后,将数据渲染到页面
            mounted(){
                // +
                console.log(document.getElementById('app').innerText)
                console.log('=======================================')
            },
            // 更新钩子函数需要改变数据才会触发
            // 更新前 data中的数据已经发生变化 未渲染到页面(页面还没同步)
            beforeUpdate(){
                // +
                console.log("更新前"+this.msg)
                // -
                console.log("更新前"+document.getElementById('app').innerText)
            },
            // 更新后
            updated(){
                // -
                console.log("更新后"+this.msg)
                // -
                console.log("更新后"+document.getElementById('app').innerText)
            },
            // 销毁Vue实例
            beforeDestroy(){
                console.log('销毁前'+this)
            },
            destroyed(){
                console.log('销毁后'+this)
            }

        })
        // 销毁Vue实例
        vm.$destroy();
    </script>
</body>
```



## 指令

####    插值表达式 

​	

```
	格式:{{}}

​		可以直接获取Vue实例中定义的数据或函数

​		支持有返回值的函数或表达式

​		注意:该方式有缺点,在网速较慢时会出现{{}} 闪烁问题
```



```html
<body>
    <div id="app">
        {{msg}}
        {{1+1}}
        
    </div>

    <script>
        var vm = new Vue({
            el:'#app',
            data:{
                msg:'zz'
            },
            methods:{
                show(){
                    return 10
                }
            }
        })
    </script>
</body>
```

####  v-text  v-html

​		为了解决插值闪烁问题提供了解决办法

​		v-text : 将数据原样输出

​		v-html : 可以将html的字符串渲染到页面

​		

```html
<body>
    <div id="app">
<!--        在网络不畅通或者网络较慢的情况下会出现闪烁问题-->
        {{msg}}</br>
<!--        解决上面插值表达式的闪烁问题-->
        <span v-text="msg"></span></br>
<!--        如果数据时html代码 可以将数据渲染到页面-->
        <span v-html="msg"></span>
    </div>

    <script>
        var vm = new Vue({
            el:'#app',
            data:{
                msg:'<font color="#8a2be2">tao</font>'
            }
        })

    </script>
</body>
```



#### v-model 加 表单元素

​		插值表达式,v-text,v-html : 只是数据的单向绑定

​		v-model可以使视图和数据进行双向绑定,互相影响

​	

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="js/vue-2.6.10.js"></script>
</head>
<body>
    <div id="app">

<!--   input文本框   将data中的num绑定到该文本框,双向绑定,修改文本框中的值 对应的在data中的num也会改变,修改data中的数据也会影响页面渲染-->
        <input type="text" v-model="num"><br/>

<!--    checkbox 多选框  需要用数组接收   -->
        <div>
            hobby:{{hobby}}
        </div>
        <input type="checkbox" v-model="hobby" value="网球">网球
        <input type="checkbox" v-model="hobby" value="游泳">游泳
        <input type="checkbox" v-model="hobby" value="跑步">跑步<br/>

<!--  radio 单选框 用普通字符串接收 -->
        <div>
            sex:{{sex}}
        </div>
        <input type="radio" value="male" v-model="sex">男
        <input type="radio" value="female" v-model="sex">女<br/>
<!--   只有一个选择框时使用布尔值接收     -->
        单复选框：<input type="checkbox" id="checkbox" v-model="checked">  <label for="checkbox">{{ checked }}</label><br/>

<!--   textarea 文本域  用普通字符串接收   -->
        <textarea  v-model="num"  cols="30" rows="10"></textarea><br/>

<!--    select 下拉列表 单选对应字符串，多选对应也是数组   -->
        下拉列表<br/>
        <select v-model="province">
            <option disabled value="">请选择</option>
            <option v-for="item in items" >{{item}}</option>
        </select>
        {{province}}
    </div>

    <script>
        // 注意: 在data中拿到的值是标签的value值
    var vm = new Vue({
        el:'#app',
        data:{
            num:1,
            hobby:[],
            checked: true,
            sex:'male',
            items:['河北','天津','北京'],
            province:''
        }
    })
</script>
</body>
</html>
```

#### 	

#### v-on

​		例子 涉及事件 

​			click keydown mouseover mouseout

​		事件处理的指令 

```html
<body>
    <div id="app">
        <input type="button" @click="buttonClick" value="点击触发事件"><br/>
<!--        键盘按下-->
        <input type="text" @keydown="show($event)">
<!--        鼠标移入移出-->
        <div style="width: 100px;height: 100px;background-color: blue;border: 5px;border-color: red" @mouseover="inDiv" @mouseout="outDiv"></div>

        <!--    判断是否是Enter键 可以用vue提供的预设好的也可以使用其对应的ascll码    -->
        <input type="button" @keydown.13="isEnter" value="按Enter键触发">
        <input type="button" @keydown.Enter="isEnter" value="按Enter键触发">
        
    </div>
   
    <script>

        var vm = new Vue({
            el:'#app',
            methods:{
                show(e){
                    console.log(e.keyCode)
                },
                inDiv(){
                    console.log("鼠标移入")
                },
                outDiv(){
                    console.log("鼠标移出")
                },
                buttonClick(){
                    console.log('点击事件')
                },
                 isEnter(e){
                    console.log(e.keyCode)
                }
            }
        })

    </script>
</body>
```

​	

####  事件冒泡+vue解决办法_按键修饰符

​	事件发生时,触发内层的事件会同时触发外层的事件

​	常用按键修饰符

​	

```
.enter  // 表示键盘的enter键
.tab
.delete (捕获 "删除" 和 "退格" 键)
.esc
.space
.up
.down
.left
.right
.ctrl
.alt
.shift
.meta
```



```html
<body>
<div id="app">

<!--    点击按钮会同时出发外层div的点击事件 并且是先触发button 后触发div -->
        <div style="width: 100px;height: 100px;background-color: red" @click="divClick">
            <input type="button" @click="buttonClick" value="点击">
        </div>

<!--    .stop 阻止冒泡 点击按钮时不会触发外层div的点击事件 -->
        <div style="width: 100px;height: 100px;background-color: black" @click="divClick">
            <input type="button" @click.stop="buttonClick" value="点击">
        </div>

<!--    .prevent 阻止事件的默认事件   -->
        <a href="http://www.baidu.com" @click.prevent="jump">百度</a><br/>
<!--    按键修饰符-->
<!--    判断是否是Enter键 可以用vue提供的预设好的也可以使用其对应的ascll码    -->
        <input type="button" @keydown.13="isEnter($event)" value="按Enter键触发">
        <input type="button" @keydown.Enter="isEnter($event)" value="按Enter键触发">

    <!--    阻止表单提交-->
        <form @submit.prevent  action="http://www.baidu.com">
              <input  type="submit" value="提交">
        </form>
    </div>

    <script>
        var vm = new Vue({
            el:'#app',
            methods:{
                divClick(){
                    console.log('div')
                },
                buttonClick(e){
                    // js中冒泡的解决方案
                    // 阻止事件的传播行为
                    // e.stopPropagation();
                    console.log('button')
                },
                jump:()=>{
                    console.log('点击a标签后没有跳转网页')
                },
                isEnter(e){
                    console.log(e.keyCode)
                }
            }
        })
    </script>
</body>
```

#### 	v-for

```html
<div id="app">

        <ul>
<!--        user  代表每一项    -->
<!--        index 代表下标 从0开始  -->
<!--        users 代表data中的数据(数组)   -->
            <li v-for="(user,index) in users">{{index}}---{{user.name}}---{{user.age}}---{{user.sex}}</li>
        </ul>
</div>        
<script>
        var vm = new Vue({
            el:'#app',
            data:{
                users:[
                    {name:"aa",age:"23",sex:"男"},
                    {name:"bb",age:"21",sex:"男"},
                    {name:"cc",age:"20",sex:"男"}
                ]
            }
        })
    </script>
```

####  	

#### 	v-if v-else-if v-else

​		**v-else 必须紧跟在 v-if 或 v-else-if 后**

​		**v-else-if 必须紧跟在v-if 或者 v-else-if 后**

​	

```html
 <div id="app">
        <div v-if="char === 'A'">
            A
        </div>
        <div v-else-if="char === 'B'">
            B
        </div>
        <div v-else="char === 'C'">
            C
        </div>

        <table border="1" cellspacing="0" width="300px" >
            <tr>
                <th>索引</th>
                <th>姓名</th>
                <th>年龄</th>
                <th>性别</th>
            </tr>
<!--        v-for 也可以和 v-if一起使用   -->
            <tr v-for="(user,index) in users" v-if="user.age > 20">
                <td>{{index}}</td>
                <td>{{user.name}}</td>
                <td>{{user.age}}</td>
                <td>{{user.sex}}</td>
            </tr>
        </table>

    </div>

    <script>
        var vm = new Vue({
            el:'#app',
            data:{
                char:'A',
                users:[
                    {name:"aa",age:"23",sex:"男"},
                    {name:"bb",age:"21",sex:"男"},
                    {name:"cc",age:"20",sex:"男"}
                ]
            }
        })
    </script>
```

​	

#### 	v-show与v-if

```html
  <div id="app">
        <input type="button" value="点击" @click="change">
<!--    不符合条件 会直接删除元素   -->
        <div v-if="flag">
            flag
        </div>
<!--    不符合条件 会在元素上添加style='display: none;'   -->
        <div v-show="flag">
            flag
        </div>
    </div>

    <script>
        var vm = new Vue({
            el:'#app',
            data:{
                flag:true
            },
            methods:{
                change(){
                    this.flag = !this.flag
                }
            }
        })
    </script>
```



#### 	 v-bind

​	**将html标签的属性与data中的数据进行绑定,可以简写为 :需要绑定的属性**

```html
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="js/vue-2.6.10.js"></script>
    <style>
        .red{
          background-color: red;
        }
        .black{
            background-color: black;
        }
        .green{
            background-color: green;
        }
    </style>
</head>
<body>
    <div id="app">
        <select v-model="myclass">
            <option disabled value="">请选择</option>
            <option v-for="color in colors"  :value="color.clas">{{color.name}}</option>
        </select>
        <div :class="myclass" style="width: 100px;height: 100px;border: yellow solid 1px">

        </div>
    </div>

    <script>
        var vm = new Vue({
            el:'#app',
            data:{
                myclass:'',
                colors:[
                    {name:'红',clas:'red'},
                    {name:'黑',clas:'black'},
                    {name:'绿',clas:'green'}
                ]
            }
        })
    </script>
</body>
```

​	

## 计算属性

​	**解决在插值表达式中书写过长或需要长期维护使用的表达式比较麻烦**

```html
<div id="app">
<!--    调用在methods中定义的方法 想要获取返回值必须使用()调用   -->

     
<!--    调用在computed中定义的方法,可以把该方法当做属性使用,本质也是一个方法,方法必须有返回值,,使用时不能使用() -->
       

    </div>

    <script>
        var vm = new Vue({
            el:'#app',
            data:{
                msg:''
            },
            methods:{
                method_num(){
                    return 1+1;
                }
            },
            computed:{
                computed_num(){
                    return 2+1;
                }
            }
        })
    </script>
```

## axios

​	用于发送http请求

​	cdn

```javascript
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
```

 在使用vue-cli脚手架创建的项目中使用

下载依赖

```javascript
npm install axios  
```

在项目中引入

全局引入需要在main.js中导入 局部引入需要在export default 上导入:

```javascript
// 导入 axios
import axios from 'axios'
// 设置请求路径的前缀
axios.defaults.baseURL='http://localhost:8080'
// 第一个axios可以当做全局的访问前缀
Vue.prototype.axios(相当于起别名) = axios
```



示例:

1. 全局 全局需要使用this.  局部不需要

   ```javascript
     export default {
           name: "list",
           data(){
               return{
                   users:[]
               }
           },
           methods:{
               findAll(){
                   this.axios.get('/user')
                       .then(res => this.users = res.data)
           },
           created() {
               this.findAll();
           }
       }
   ```

   

​      2.局部

```vue
    // 局部引入axios 不需要this
    // import axios from 'axios'
    // axios.defaults.baseURL='http://localhost:8080'

    export default {
        name: "list",
        data(){
            return{
                users:[]
            }
        },
        methods:{
            findAll(){
                axios.get('/user')
                    .then(res => this.users = res.data)
            }
        },
        created() {
            this.findAll();
        }
    }
```

​	git传递对象参数

```javascript
this.axios.get('url',{
    params : 对象
})
```

​	delete传递参数 数组

​	需要配合qs使用

```javascript
安装
npm install qs

main.js 中配置
import qs from 'qs'
Vue.prototype.qs = qs
```



```javascript
this.axios.delete("/book", {
    params: {
        books: arr
    },
    paramsSerializer: params => {     // false 用来控制格式
        return qs.stringify(params, { indices: false })
    }
}).then(() => {
    this.getPageInfo(this.num, this.size);
})

```



## 路由

###  router-link & router-view

```html
<!-- 相当于a标签 但是a标签有刷新页面的效果 体验不好 -->
<router-link to="/"> :<!--  组件跳转 to 可以直接写地址,也可传参(后面讲)-->

    
<router-view/> : <!-- 组件跳转后,用来显示其内容   -->
   
```

### 	配置路由:

​	使用vue-cli创建项目后就已做好的:

​		在**router/index.js**文件中 导入 vue-router并使用

```javascript
// 导入 导入时名字可以随便起,但在use名字时必须相同
import Vue from 'vue'
import VueRouter from 'vue-router'
// 导入组件 全局引入
import Home from '../views/Home'

// 使用
Vue.use(VueRouter)

// 创建路由 数组
const routes = [
  // path:访问路径
  // name:路由名称
  // component:要跳转到的组件 需要导入  
  {
    // 写路径时记得写 /  
    path: '/',
    name: 'home',
    component: Home,
    // 再使用时引入的方式,可以提高首页显示速度 
    // component: () => import('../views/Home.vue')  
  }
]

```

​	**main.js**

```javascript
import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

Vue.config.productionTip = false;

new Vue({
  router, // 相当于 router:router
  store,
  render: h => h(App)
}).$mount('#app');

```

### 	style scope

```html
<!-- 代表该样式表只在该组件中生效 -->
<style scoped>

</style>
```

### 	export default

```javascript
// 就是vue的实例 是es6的语法 和之前写的差别是,data只能按照这种格式(和写时组件一样)  
export default {
        name: "list",
        methods:{
          to(){
              alert("list")
          }
        },
        data(){
            return{
                msg:'msg'
            }
        }
    }
```

### 	路由传参

两种方法的路由配置

```javascript
  {
    path: '/edit',
    name: 'edit',
    component: Edit
  },
```



#### 		1.name+params

```html
<!-- 传参 -->
<!-- 传递id 如果需要数据的属性记得绑定 :=v-bind --> 
<!-- 该方式是在路由配置中根据路由的name找组件 -->
<router-link :to="{name: 'edit',params: {id: u.uid}}">修改</router-link>
```

```javascript
// 接收 
this.$route.params.id
```



#### 		2.path+query

```html
<!-- 传参 -->
<!-- 接收  该方式是在路由配置中根据路由的path找组件 -->
<router-link :to="{path: '/edit',query: {id: u.uid}}">修改</router-link>
```

```javascript
// 在地址栏填写参数也是使用该方式获取
this.$route.query.id;
```



#### 		3.路由传参(地址栏)

```javascript
// 在路由的path后添加 :参数名
{
	path: '/edit/:id',
	name: 'edit',
	component: Edit
}
```

该方法路由跳转的三种方式

```html
<!-- 直接在路径后传递参数 -->
<router-link to="/edit/非动态">修改</router-link>
<router-link :to="/edit/动态数据">修改</router-link>
this.$router.push({
     path: '/edit/111',
})
```

```javascript
// 接收
this.$route.params.id
```

### 	路由跳转

```javascript
this.$router.push(路由的path)
```

同样适用于传参

方式一:根据路由的name匹配路由

路由配置

```javascript
 {
    path: '/edit',
    name: 'edit',
    component: Edit
  },
```

跳转路由

```javascript
 this.$router.push({
      name:'edit',
      params:{
          id : 888
      }
 })
```

获取路由中的参数

不会表现在地址栏上

```javascript
this.$route.params.id
```

方式二:根据路由的path匹配路由

路由配置

```javascript
  {
    path: '/edit',
    name: 'edit',
    component: Edit
  },
```

跳转路由

```javascript
  this.$router.push({
 	 path:'/edit',
	 query:{
 	  	id : 111
      }
  })
```

获取参数

```javascript
this.$route.query.id
```

表现在地址栏

```
http://localhost:8080/edit?id=111
```



### 	嵌套路由

​	在一个组件中引入了另一个组件,相当于父与子的关系

```html
<!--定义一级路由 -->
<template>
    <div>
        我是父页面
        <router-link to="/father/son">去子页面</router-link>
        <router-view/>
    </div>
</template>

<!--定义二级路由 -->
<template>
    <div>
        我是子页面
    </div>
</template>
```

​	router/index.js 配置

```javascript
const routes = [
  // path:访问路径
  // name:路由名称
  // component:要跳转到的组件 需要导入
  {
    path: '/father',
    name: 'father',
    component: () => import('../views/father.vue'),
    children:[
      {
        // 注意子路由不能加 /
        path: 'son',
        name: 'son',
        component: () => import('../views/son.vue'),
      },
     //  子路由path的第二种写法,访问路径加上父组件的路径
     // {
     //   path: '/home/son',
     //   name: 'son',
     //   component: () => import('../views/son.vue')
     // }    
    ]
  }
]
```







## Vuex

### 什么是Vuex,为什么要有Vuex

​		Vuex是组件之间数据共享的一种机制

​		使用父子传值或兄弟传值,太麻烦不好管理,有了Vuex想要共享数据,只需要把数据挂在到vuex就行,想要获取数据,直接从vuex上拿就行,vuex中的数据被修改后其他引用了此数据的组件,也会同步更新

### 在项目中使用vuex

​		安装vuex:

```shell
npm install vuex
```

​		使用

```vue
在store/index.js文件
import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  // 公共区域数据
  state: {
    num : 10,
  },
  mutations: {
  },
  actions: {
  },
  modules: {
  }
})

```



```java
在main.js文件中将store挂在到vm实例上

import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')

```



### 	访问vuex中的数据及方法

#### state,mutations,getters

官方文档:https://vuex.vuejs.org/zh/guide/getters.html

getters是从state中派生的数据,对state中的数据进行过滤修改,并且可以传参返回

在store/index.js中定义变量存储数据

```javascript
import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  // 公共区域数据
  state: {
    num : 10,
  },
  mutations: {
      // 第一个参数默认是state
    addNum(state){
      state.num++
    }
  },
})

```

在components中创建两个组件

```html
<!-- add.vue -->
<template>
    <div>
        <!-- 第一种方式 -->
        <!--  add:<input type="button" value="+" @click="$store.state.num++"> -->
        <!-- 第二种方式 这两种方式官方都不推荐 -->
        add:<input type="button" value="+" @click="add">
        
        <!-- 使用解构表达式 -->
        <!-- 直接调用mutations 中的方法 -->
        <!-- 官方不推荐   add:<input type="button" value="+" @click="$store.commit('addNum')">-->
        <!-- 官方推荐方式:使用解构表达式 -->
        add:<input type="button" value="+" @click="addNum">
        num:{{num}}
    </div>
</template>

<script>
    // 解构表达式
    import {mapState,mapMutations} from 'vuex'
    export default {
        name: "add",
        // 官方推荐的使用方式,进行结构,将公共属性的值作为计算属性
        computed:{
            ...mapState(['num','msg'])
        },
        methods:{
            add(){
                this.$store.state.num++
            },
            ...mapMutations(['addNum'])
        }
    }
</script>

```

​	minus.vue

```html
<template>
    <div>
      {{num}}
    </div>
</template>

<script>
    // 解构 将vuex中的数据解构成计算属性使用
    import {mapState} from 'vuex'
    export default {
        name: "add",
        methods:{},
        computed:{
            ...mapState(['num'])
        }
    }
</script>
```

​	router/index.js

```javascript
// 将这两个组件导入
import add from '@/components/add.vue'
import minus from '@/components/minus.vue'

const routes = [
    {
    path:'/访问路径',
    name:'home',
    // 这里是简写方式次里是简写方式 相当于 add:add,minus:minus
    // 前面是路由名称,后面是组件名称,相同时可以简写    
    components:{
      add,
      minus
    }
   },
]

```

​	App.vue:用于显示变量,观察其修改后两个组件中数据是否同步更新

```html
  // 这里的name对应路由配置中components中所写即可
  <router-view name="add"></router-view>
  <router-view name="minus"></router-view>
```

​	

#### 	actions

​	登录案例

```vue
<template>
    <div>
        <h3>登录</h3>
        账号: <input type="text" v-model="user.username"> <br>
        密码: <input type="text" v-model="user.password"> <br>
        <!-- <input type="button" @click="login()" value="提交"> -->
        <input type="button" @click="asyncLogin(user)" value="登录">
    </div>
</template>

<script>
    import {mapActions} from 'vuex'
    export default {
        methods:{
            login(){
                // 官方并不推荐直接调用actions中的方法
                this.$store.dispatch('asyncLogin',this.user)
            },
            ...mapActions(['asyncLogin']),
        },
        name: "Login",
        data(){
            return{
                user:{}
            }
        },
    }
</script>
```

store/index.js

```javascript
 mutations: {
     // 第一个参数默认state
    login(state,user){
      console.log(user)
    }
  }, 
actions: {
     // 第一个参数默认context
    asyncLogin(context,user){
        // 调用的mutations中的方法,进行封装使之可以提交异步请求
      context.commit('login',user)
    }
  },
```



### mutations传参问题

​	如果在调用mutations中的方法时,方法有多个参数,后面的参数是undefined

​	将参数封装成对象进行传值



###  注意事项

​	如果想获取有返回值的方法(对state中的数据有所更改后),可以在getters中创建方法,并

返回处理后的结果,使用this.$store.getters.方法名获取

​	vue推荐使用mutations来对state中的数据进行修改,mutations中的方法第一个参数必

须是state,也就是当前vuex中的state,可以直接调用

​	actions:包裹mutations中的方法,异步调用

​	例子:

```javascript
mutations:{  
// 第一个参数必须是state
  addNumS(state,step){
      state.num += step
  },
},
actions: {
    // 第一个参数必须是context step:参数
    addNumSAysc(context,step){
        // 利用context来调用mutations的方法来操作state中的数据
        context.commit('addNumS',step)
      }
 },    
```



## 组件之间传值

### 	父传子

​	父组件

```vue
<template>
    <div>
        我是父组件
<!--      使用子组件  -->
        <son :sonMsg="msg"></son>
    </div>
</template>

<script>
    // 导入子组件
    import son from '@/views/Son'

    export default {
        name: "Parent",
        data(){
            return{
                msg : '我是父组件中的数据'
            }
        },
        // 注册使用
        components:{son}
    }
</script>
```

​	子组件

```vue
<template>
    <div>
        我是子组件:{{ sonMsg }}
    </div>
</template>

<script>
    export default {
        name: "Son",
        // 定义props属性用来接收父组件的数据
        props:['sonMsg']
    }
</script>
```

### 	子传父

​	父组件

```vue
<template>
    <div>
            <p>我是父组件</p>
        我是子组件传递到父组件的数据:{{sonMs}}
        <hr>
<!--     父组件监听   -->
        <son @fromSon="sonSMsg"></son>
    </div>
</template>

<script>
    // 导入子组件
    import son from '@/views/Son'

    export default {
        name: "Parent",
        data(){
            return{
                msg : '我是父组件中的数据',
                sonMs: ''
            }
        },
        methods:{
          sonSMsg(msg){
              this.sonMs = msg
          }
        },
        // 注册使用
        components:{son}
    }
</script>
```

​	子组件

```vue
<template>
    <div>
        我是子组件中的按钮
<!--     子组件触发自身事件调用方法   -->
        <input type="button" @click="sendMsgToParent" value="点击传值">
    </div>
</template>

<script>
    export default {
        name: "Son",
        data(){
          return{
              msg:'我是子组件中的数据'
          }
        },
        methods : {
            sendMsgToParent(){
                this.$emit('fromSon',this.msg)
            }
        }
    }
</script>
```

### 	非父子组件之间传值

​	设立公共数据文件

​	Bus.js

```javascript
// 导入vue
import vue from 'vue'
// 创建vue对象
export default new vue()
```



​	Demo01.vue

```vue
<template>
    <div>
<!--    点击触发事件 调用方法  -->
        <input type="button" @click="sendMsgToDemo02" value="点击传值">
        <hr>
<!--    使用兄弟组件  为了将其显示在同一个页面   -->
        <demo02></demo02>
    </div>
</template>

<script>

    // 导入 兄弟组件 为了将其显示在同一个页面
    import demo02 from '@/views/Demo02'

    // 导入Bus.js 公共数据文件
    import bus from './Bus.js'

    export default {
        name: "Demo01",
         data(){
             return{
                msg : '我是demo01中的数据'
             }
         },
        methods:{
            sendMsgToDemo02(){
                // 固定格式
                bus.$emit('fromDemo02',this.msg)
            }
        },
        components:{demo02}
    }


```

​	Demo02.vue

```vue
<template>
    <div>
        <p>我是demo02:</p>
        我是传递过来的数据:插值表达式 msg
    </div>
</template>

<script>

    // 导入Bus.js 公共数据文件
    import bus from './Bus.js'

    export default {
        name: "Demo02",
         data(){
             return{
                 msg : ''
             }
         },
        created() {
            // 固定格式 data就是传递过来的数据
            bus.$on('fromDemo02',data => {
                this.msg = data
            })
        }
    }
</script>
```



## 导航守卫

  导航守卫的主要作用就是为了拦截导航路由,使之可以跳转或者取消,有多种方式注册路由导航钩子



### 全局的

在 main.js中注册一个全局的路由导航钩子

```javascript
/**
 * to : 路由将要跳转的路由的信息
 * from : 路径跳转前的路径信息
 * next :
 *    next() : 放行
 *    next(false) : 返回原来的页面
 *    next('路径') : 改变路由跳转地址 跳转指定路由
 */
router.beforeEach((to,from,next)=>{
  
})
```



### 单个路由独享的

```javascript
  {
    path: '/login',
    name: 'login',
    component: Login,
    beforeEnter(to,from,next) {
      
    }
  }
```



### 组件级别的

```javascript
 export default {
        name: "Login",
        beforeRouteEnter(to, from, next) {
            console.log("准备进入登录");
            next();
        },
     	beforeRouteUpdate(to,from,next){
     	    console.log('路由发生改变,组件被复用时触发')
    	},
        beforeRouteLeave  (to, from, next)  {
            console.log("准备离开登录");
            next();
        }
    }
```



















