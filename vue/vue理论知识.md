# 1.MVVM中,MVVM分别代表什么?作用是什么

​	MVVM是model-view-viewModel的简写,是MVC的改进版

​	为了分离model(模型)和view(视图),再由viewModel将v和m连接起来

​	当model(模型)发生改变时,通过MVVM框架自动更新view视图状态

​	当view(视图)发生改变时,通过MVVM框架自动更新model模型数据

# 2.简述什么是单页,以及单页的优缺点

​	总:项目中只有一个html页面,由多个组件构成

​	优点:速度快,用户体验好,修改内容不会刷新整个页面,因此,spa对服务器的压力也会变小;前后端分离;页面效果炫酷(比如切换页面时的专场动画)

​	缺点:初次加载耗时长;提高页面复杂度;不利于seo;导航不可用,如果需要使用需要自行完成后退前进功能

# 3.Vue项目中的src文件夹一般放置那些文件及文件夹

​	assets:静态资源目录

​	components:功能组件

​	views:页面组件

​	store:vuex的数据

​	router:路由文件

​	App.vue:入口页面

​	main.js:全局的配置文件

# 4.简述vue的声明周期及钩子函数

​	vue的生命周期就是该vue实例从创建到销毁的过程

​	beforeCreat:创建完成之前,数据未完成初始化

​	created:创建完成后,数据已完成初始化,一般用于页面渲染

​	beforeMount:双向绑定前

​	mounted:双向绑定后

​	beforeUpdate:更新前

​	updated:更新后

​	beforeDestroy:销毁前

​	destroyed:销毁后

# 5.前后台分离,怎么解决跨域问题

​	1.jsonp:叫古老的方式,利用script标签可跨域的特性,缺点是只能发送get请求

​	2.nginx:配置代理服务器,使其可以访问目标服务器,然后再将目标服务器返回的数据返回到我们的客户端,可以发送各种请求

​	3.比较常用的cors,需要后端设置Access-control-Allow-Origin头,可以自行配置可跨域的地址,缺点是可能会发生两次请求

# 6.Vue-router的作用是什么

​	vue-router是vue.js官方的路由管理器

​		<router-link>:完成组件之间的切换

​		this.$route : 完成组件之间的传参

​		this.$router.push():完成组件之间的跳转

# 7.Vue中父子组件之间如何传值是怎么实现的

​	1.父传子:在子组件中设置props属性用于接受父组件传递的数据

​	2.子传父:子组件触发自身的方法,使用$emit调用父类的监听的方法

​	3.非父子组件:需要设立公共的文件

# 8.Vue如何传参	

​	1.query+path

```html
传参:
<router-link :to="{path:"/组件的path",query:{参数名:值}}">
获取值:
this.$route.query.参数名    
```

​	2.params+name

```html
传参:
<router-link :to="{name:"组件的name",params:{参数名:值}}">
获取值:
this.$route.params.参数名
```

​	3.路由传参(地址栏)

```javascript
在路由组件的配置上添加
{
    path:'/path/:参数名'
    name:
    component:
}

获取值:
	this.$route.params.参数名

```

# 9.Vuex怎么实现数据共享

​	vue整合vuex,在main.js中以组件的方式导入store.js文件

​	在store.js文件的state区域保存数据,使之可以在任何位置可被访问

​	使用store.js文件中的mutations可以更新state区域的数据,通过读写完成数据的共享

# 10.Vue的全家桶有哪些

​	Vue的两大核心:

​		组件化:将一个整体应用,拆分成多个可复用的个体(组件)

​		数据驱动:在修改数据的前提下,不操作dom,直接影响bom显示

​	vue-router:路由,组件之间的切换

​	vue-cli:构建vue单页应用的脚手架工具

​	vuex:状态数据

​	axios:vue官方推荐的发送http请求的工具包

# 11.Vue的导航守卫是什么?有什么作用?

​	vue-rouer提供的导航钩子,主要用来拦截导航,完成跳转或取消,有多种方式可以在路由导航发生时执行路由导航钩子

​	全局的:

​		router.beforeEach在全局注册一个before钩子

​	单个路由独享的:

​		在路由配置中直接定义一个beforeEnter路由导航钩子

​	组件级别的:

​		beforeRouteEnter,beforeRouteUpate,beforeRouteLeave

​		直接在路由组件中定义路由导航钩子

# 12.Vuex的五大核心属性

​	Vuex是专门为vue.js应用设计的状态管理架构

​	1.state:基本数据

​	2.getters:从基本数据派生的数据

​	3.mutations:更改数据的提交方式,同步

​	4.actions:像一个装饰器,用来包裹mutations,使之可以异步

​	5.modules:模块化vuex

# 13.var let const的区别

​	var是es3提供的创建变量的关键字,定义的变量为全局变量

​	let是es6新增的定义变量的关键字,定义的变量是局部变量

​	const定义的变量的常量

# 14.Vue中常用的指令

​	v-if:当条件为true时,显示该元素

​	v-show:修改页面元素的css样式完成显示或隐藏

​	v-on:为标签添加事件

​	v-model:双向绑定,用于数据和视图的同步

​	v-bind:将数据绑定的标签的属性上

​	v-for:遍历数组

# 15.Vue中的事件修饰符

​	.stop:阻止冒泡

​	.prevent:禁止默认事件

​	.capture:捕获

​	.once:只执行一次	

​	.self:只在自身触发

# 16.什么是js的冒泡事件

​	当触发页面中标签的事件时,会同时触发其所有父与子标签的事件,直到跟标签

# 17.什么是计算属性,如何理解

​	计算属性本质是一个有返回值的方法,在页面渲染时,可以将该方法当做一个属性使用,当data中的数据未发生改变时,计算属性直接读取缓存

# 18.import.export导入和导出

​	是es6中,module主要构成的两个命令

​	export:用于导出模块中的变量的接口

​	import:用于在一个模块中导入另一个含有export接口的接口











