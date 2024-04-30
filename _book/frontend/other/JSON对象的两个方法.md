# JSON对象的两个方法

## JSON.parse(string)

​	接受一个JSON字符串并将其转换成一个JavaScript对象

## JSON.stringify(obj)

​	接受一个JavaScript对象并将其转换为一个JSON字符串

```java
<script >
        // 创建一个字符串
        var userStr = '{"name":"taoqz","gender":"man","age":"18"}';
        // 打印字符串并且验证其类型
        console.log(userStr) // {"name":"taoqz","gender":"man","age":"18"}
        // 可以查看对象的类型
        console.log(typeof (userStr)); // string

        // 将一个标准的json字符串转为JavaScript对象
        var userToObJ = JSON.parse(userStr)
        // {name: "taoqz", gender: "man", age: "18"}
        // age: "18"
        // gender: "man"
        // name: "taoqz"
        // __proto__: Object
        console.log(userToObJ)
        // object
        console.log(typeof (userToObJ));

        // 将一个JavaScript对象转换为一个JSON字符串
        var objToStr = JSON.stringify(userToObJ);
        console.log(objToStr)
        // string
        console.log(typeof objToStr)
</ script>
```

## 数组

```java
<script>
    // 在数组上同样适用
    const arr = ['Java', 'Python', 'PHP']
	console.log(arr)
	console.log(typeof arr) // object
    
	const arrStr = JSON.stringify(arr);
	console.log(arrStr)
	console.log(typeof arrStr) // string
</script>
```

JSON.parse()方法的第二个参数

```java
 <script>
        console.log('---------------------------')
        let empStr = '{"name":"taoqz","gender":"man","age":18}'

        // JSON.parse()可以接受第二个参数,可以对对象值的属性进行操作
        const newEmp = JSON.parse(empStr, (key, value) => {
            console.log('key:' + key + " value:" + value)
            // return value;
            // 如果value是string类型,该键值对将不会被过滤
            if (typeof value === 'string') {
                // 可以对value进行操作
                // return value.toUpperCase();
                // 返回undefined 将会排除该键值对
                return undefined
            }
            return value;
        })
        // 最终结果只有age
        console.log(newEmp)
    </script>
```

JSON.stringify的三个参数

```java
<script>
        console.log('---------------------------')

        let emp = {
            name: 'taoqz',
            gender: 'man',
            age: 18,
            hobbies:[
                'swim',
                'run'
            ],
            getHeight:function(){
                return '1.78';
            }
        };

        // 分别接受了三个参数,第一个参数是要被转换的JavaScript对象
        // 第二个参数是一个方法,同样支持可以通过对key进行判断及对value进行操作
        // 第三个参数是用来在打印时进行格式化
        let empStr2 = JSON.stringify(emp,function (key,value) {
            // 将会在序列化时排除age这个key
            if (key === 'age') {
                return undefined
                    // 因为序列化时,默认是不会序列化方法的,这会使方法加入序列化
            }else if(typeof(value) == 'function'){
                return Function.prototype.toString.call(value)
            }
            return value;
        },4);

        // {
        //     "name": "taoqz",
        //     "gender": "man",
        //     "hobbies": [
        //     "swim",
        //     "run"
        // ],
        //     "getHeight": "function(){\n                return '1.78';\n            }"
        // }
        console.log(empStr2)

    </script>
```

## toJSON问题

```java
<script>
    console.log('--------------------')
    let myObj = {
 	   name : 'myObj',
   	   age : 18,
       toJSON: function () {
           return 'toJSON!!'
       }
	}
	// 只会序列化toJSON方法的返回值
	// "toJSON!!"
	console.log(JSON.stringify(myObj))
</script>
```

