# React Native

基于React,可以用来开发移动应用,提出了Learn once,write anywhere,一份代码同时支持在IOS和Android上运行。

## 搭建环境

需要JDK,Node,Python2

使用facebook体用的替代npm的工具

```shell
# 安装完成后就可以用yarn代替npm了,例如用yarn代替npm install,使用yarn add代替npm install
npm install -g yarn
```

需要安装SDK(安卓的开发环境),Android Studio(安卓开发工具),这里主要使用其模拟机的功能。

将以下工具目录添加到环境变量中(是安卓的SDK目录)

```shell
%ANDROID_HOME%\platform-tools
%ANDROID_HOME%\emulator
%ANDROID_HOME%\tools
%ANDROID_HOME%\tools\bin
```

## 创建项目

如果你之前全局安装过旧的`react-native-cli`命令行工具，请使用`npm uninstall -g react-native-cli`卸载掉它以避免一些冲突。

```shell
npx react-native init AwesomeProject
```

如果安装好Android Studio开发工具会自动启动模拟机,前提是你已经通过该开发工具创建过一个模拟机了。

启动项目,首先需要进入项目的根目录

```shell
# 进入项目
cd AwesomeProject
# 这会在模拟机上安装apk
yarn android 或者
yarn react-native run-android
```

启动成功后,首次会出现红屏警告或者提示连接失败,需要在键盘上按ctrl+m,打开settings,设置Debug server host & port for device,添加127.0.0.1:8081。

## 使用真机

需要先打开手机上的USB调试功能

```shell
# 查看当前连接设备
adb devices
# 连接成功后,开启Reload JS
adb reverse tcp:8081 tcp:8081
```

摇晃手机选择settings,选择Debug server host & port for device

填入127.0.0.1:8081,也就是应用的本地端口。

## 使用夜神模拟器

使用真机和Android Studio自带的模拟机会自动在开发工具中唤醒node窗口,可以使用夜神模拟器来避免开启更多窗口。

安装好夜神模拟器后,在bin目录执行,使用管理员命令行窗口

```shell
# 连接模拟器,62001则是夜神模拟器的默认端口
adb connect 127.0.0.1:62001
# 查看是否连接成功
adb devices
# 启动项目,这会在模拟器上安装应用
yarn android
# 安装成功后同样打开settings(使用模拟器的摇一摇),设置ip:port,但此时需要使用ipv4地址
# 关闭项目,使用另一条命令启动项目,会直接在开发工具中打开node,方便更新和查看log
react-native start --port=8081
```

## 样式

```react
const App: () => React$Node = () => {
    return (
        <>
            {/*引用样式*/}
            <View style={styles.view}>
                <Text>Hello, World123</Text>
            </View>
        </>
    );
};

// 定义样式对象
const styles = StyleSheet.create({
    view: {
        height: 200,
        width: 200,
        backgroundColor: 'rgb(226, 32, 20)'
    }
});
```

```react
import React, {Component} from 'react'
import {View, Text} from 'react-native'

const App = () => {
    return (
        <View>
            <View>
                <Text>没有任何样式</Text>
            </View>

            {/*style 中相当于是有一个样式的对象*/}
            <View style={{marginTop: 8, padding: 8, backgroundColor: 'blue'}}>
                <Text style={{color: 'white'}}>背景是蓝色的,文字是白色的</Text>
            </View>

            <View style={{marginTop: 8, padding: 8, width: 300, backgroundColor: 'red'}}>
                <Text style={{color: 'green'}}>
                    背景是红色的,文字是绿色的
                </Text>
            </View>
        </View>
    )
}
```

```react
import React from 'react'
import {View, StyleSheet} from 'react-native'

export default class App extends React.Component {
    render() {
        return (
            <View style={styles.container}>
                {/*有样式继承,会继承父容器中的样式*/}
                <View style={styles.card}></View>
                {/*行内样式的优先级高*/}
                <View style={{marginTop: 8, marginBottom: 8, height: 100, backgroundColor: 'blue'}}></View>
                {/*设置多个样式对象,数组*/}
                <View style={[styles.card, {backgroundColor: 'yellow'}]}></View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        padding: 8,
        backgroundColor: 'green'
    },

    card: {
        height: 100,
        // 设置边框的颜色
        borderColor: 'red',
        // 设置边框的宽度
        borderWidth: 10,
        // 设置边框的样式 实线 虚线等
        borderRadius: 10,
    }
});

```

## Flex布局

可以在该网站进行练习:https://yogalayout.com/

```react
import React, {Component} from 'react'
import {View, StyleSheet} from 'react-native'

export default class App extends React.Component {
    render() {
        return (
            <View style={styles.container}>
                {/*这三个组件将整个屏幕分为了6份 其中每块占用了指定的部分*/}
                <View style={{flex: 1, backgroundColor: 'red'}}></View>
                <View style={{flex: 2, backgroundColor: 'black'}}></View>
                <View style={{flex: 3, backgroundColor: 'yellow'}}></View>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        padding: 8,
        backgroundColor: 'red'
    }
});
```

## 加载动画ActivityIndicator

```react
import React from 'react'
import {View, StyleSheet, ActivityIndicator} from 'react-native'

export default class ActivityIndicators extends React.Component {

    // 用来控制是否显示
    state = {
        animating: true
    }

    closeActivityIndicator = () => {
        // 设置打开两秒后关闭
        setTimeout(() => this.setState({animating: false}), 2000)
    }

    componentDidMount(): void {
        this.closeActivityIndicator()
    }

    render() {
        const {animating} = this.state;
        return (
            <View style={styles.container}>
                <ActivityIndicator
                    // 是否隐藏 true不隐藏
                    animating={animating}
                    // animating={true}
                    // 设置圈圈的颜色
                    color={'green'}
                    // 设置大小,默认是small
                    size={'large'}
                    style={styles.activityIndicator}/>
            </View>

        )
    }
}

const styles = StyleSheet.create({
    container: {
        marginTop: 70
    },
    activityIndicator: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        height: 80
    }
})
```

## 动画Animated

```react
import React from 'react'
import {
    Animated,
    StyleSheet,
    TouchableOpacity,
} from 'react-native'

export default class AnimatedDemo extends React.Component {

    // 在组件将要渲染时设置默认值
    componentWillMount = () => {
        // 分别设置宽和高
        this.animatedWidth = new Animated.Value(50)
        this.animatedHeigth = new Animated.Value(100)
    }

    animatedBox = () => {
        Animated.timing(this.animatedWidth, {
            // 设置动画结束后的值
            toValue: 200,
            // 设置动画的时长 默认是500
            duration: 1000
            // 开启一个动画
        }).start()


        Animated.timing(this.animatedHeigth, {
            toValue: 500,
            duration: 500
        }).start()
    }

    render() {
        const animatedStyle = {
            width: this.animatedWidth,
            height: this.animatedHeigth
        }
        return (
            <TouchableOpacity
                style={styles.container}
                // 点击这个组件时 开启动画
                onPress={this.animatedBox}>
                {/*开启动画后初始值会得到改变,并进行更新, animatedStyle的样式会覆盖左边的样式,也就是覆盖初始box的样式*/}
                <Animated.View style={[styles.box, animatedStyle]}/>
            </TouchableOpacity>
        )
    }

}

const styles = StyleSheet.create({
    container: {
        justifyContent: 'center',
        alignItems: 'center'
    },
    box: {
        backgroundColor: 'blue',
        width: 50,
        height: 100
    }
})

```

## Image

```react
import React from 'react'
import {View, StyleSheet, Image} from 'react-native'

// 图片组件的使用
export default class Images extends React.Component {

    render() {
        return (

            <View>
                <Image
                    // 设置样式,并不是图片的样式
                    style={{height: 400, width: 400, backgroundColor: 'red'}}
                    // 设置图片的地址(本地)
                    // source={require('./img/git_header.jpg')}
                    // 引用网络图片,必须在style中指定高度和宽度
                    source={{uri: 'https://www.twle.cn/static/upload/img/2019/07/14/20190714195524_4.jpg'}}
                    // 设置图片如何适应图片容器
                    resizeMode={"center"}
                />

                {/*base64 同样需要设置style*/}
                <Image
                    style={{margin: 10, width: 66, height: 58}}
                    source={{uri: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADMAAAAzCAYAAAA6oTAqAAAAEXRFWHRTb2Z0d2FyZQBwbmdjcnVzaEB1SfMAAABQSURBVGje7dSxCQBACARB+2/ab8BEeQNhFi6WSYzYLYudDQYGBgYGBgYGBgYGBgYGBgZmcvDqYGBgmhivGQYGBgYGBgYGBgYGBgYGBgbmQw+P/eMrC5UTVAAAAABJRU5ErkJggg=='}}
                />

            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        paddingTop: 23
    }
});
```

## State

```react
import React, {Component} from 'react';
import {View, Text, StyleSheet} from 'react-native';

export default class StateDemo extends React.Component {

    // 是一个对象
    // state = {
    //     name: 'zs',
    //     age: 12
    // };

    // 在构造函数中进行初始化,会覆盖外部state中的值
    constructor() {
        super();
        this.state = {
            name: 'lisi',
            age: 30,
            flag: true
        }
    }

    updateState = () => {
        const flag = this.state.flag;
        this.setState({flag: !flag})
        alert(flag)
    };

    render() {
        // 不推荐使用this.state.key 访问变量值
        // return(
        //     <View style={styles.container}>
        //         <Text>名称:{this.state.name}</Text>
        //         <Text>年龄:{this.state.age}</Text>
        //     </View>
        // )

        // 使用结构表达式
        const {name, age, flag} = this.state;
        return (
            <View style={styles.container}>
                <Text>名称:{name}</Text>
                <Text>年龄:{age}</Text>

                {/*有个问题待解决 直接拿flag不会显示*/}
                <Text>标记:{'flag:' + flag}</Text>

                <Text onPress={this.updateState}>点击文字更新标记{'flag:' + flag}</Text>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        margin: 10
    }
});
```

## Props父子组件传值

```react
import React, {Component} from 'react'
import {View, Text, StyleSheet} from 'react-native'

class SetNumComponent2 extends React.Component {

    constructor(props) {
        super(props);
        // 获取传递过来的数值并且赋值给组件的state中
        this.state = {num: props.num}
    }

    updateState = () => {
        const num = this.state.num == 1 ? 2 : 1;
        this.setState({num: num})
    };

    render() {
        const {num} = this.state
        return (
            <View>
                <Text onPress={this.updateState}>{num}</Text>
            </View>
        )
    }
}

export default class App extends React.Component {

    render() {
        return (
            <View style={styles.container}>
                {/*将1传递到 组件中*/}
                <SetNumComponent2 num={1}/>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        margin: 10
    }
})

```



## Alert

```react
import React from 'react'
import {Alert, View, Text, TouchableOpacity, StyleSheet, Button} from 'react-native'

const App = () => {

    const showAlert = () => {
        // 默认只有ok一个确认键
        Alert.alert('发送数据成功')
    }

    return (
        <View>
            {/*这是组件本质上是一个透明组件,点击的效果是涟漪*/}
            <TouchableOpacity onPress={showAlert} style={styles.button}>
                <Text>发送</Text>
            </TouchableOpacity>
            {/*而Button按钮点击后没有任何的效果*/}
            <Button
                title='发送Button'
                onPress={showAlert}
            />
        </View>
    )
}

export default App

const styles = StyleSheet.create({
    button: {
        backgroundColor: '#4ba37b',
        width: 100,
        // 设置组件的圆润程度
        borderRadius: 50,
        // 设置组件内部的文字的居中
        alignItems: 'center',
        marginTop: 100
    }
})

```

```react
import React from 'react'
import {Alert, Text, TouchableOpacity, StyleSheet} from 'react-native'

const App = () => {

    // 提示删除数据成功
    const showTip = () => {
        Alert.alert('删除数据成功')
    }

    const showAlert = () => {
        Alert.alert(
            '警告',
            '确认删除？',
            [
                // 点击确认调用showTip方法
                {text: '确认', onPress: () => showTip()},
                {text: '取消', style: 'cancel'},
            ],
            {cancelable: false}
        )
    }

    return (
        // 点击后调用方法 showAlert
        <TouchableOpacity onPress={showAlert} style={styles.button}>
            <Text>删除</Text>
        </TouchableOpacity>
    )
}

export default App

const styles = StyleSheet.create({
    button: {
        backgroundColor: '#4ba37b',
        width: 100,
        borderRadius: 50,
        alignItems: 'center',
        marginTop: 100
    }
})
```

## StatusBar状态栏

```react
import React, {Component} from 'react';
import {View, Text, StatusBar, StyleSheet, TouchableOpacity} from 'react-native'

class App extends Component {

    state = {
        hidden: false,
        barStyle: 'default'
    }

    changeHidden = () => {
        var hidden = this.state.hidden ? false : true;
        this.setState({hidden: hidden})
    }

    changeBarStyle = () => {
        var barStyle = this.state.barStyle == 'light-content' ? 'dark-content' : 'light-content';
        this.setState({barStyle: barStyle})
    }

    render() {
        return (
            <View>
                {/*// barStyle 设置高亮或者灰色*/}
                {/*// hidden 是否隐藏状态栏*/}
                <StatusBar barStyle={this.state.barStyle} hidden={this.state.hidden}/>
                <TouchableOpacity style={styles.button} onPress={this.changeHidden}>
                    <Text>显示或隐藏</Text>
                </TouchableOpacity>
                <TouchableOpacity style={styles.button} onPress={this.changeBarStyle}>
                    <Text>改变主题色</Text>
                </TouchableOpacity>
            </View>
        )
    }
}

export default App

const styles = StyleSheet.create({
    button: {
        backgroundColor: '#4ba37b',
        width: 100,
        borderRadius: 50,
        alignItems: 'center',
        marginTop: 100
    }
})
```

## AsyncStorage

存储数据组件 AsyncStorage

React Native 提供了 `AsyncStorage` 组件用于存储数据。

在 `0.60` 版本之前，这个组件是内置的，`0.60` 版本把它移到了 [react-native-community/react-native-async-storage](https://github.com/react-native-community/react-native-async-storage)。

AsyncStorage 是一个简单的，未加密的，异步的，持久的键值存储系统。

AsyncStorage 是一个全局的存储系统，没有实例这一概念。要存储数据就往里面扔，要读取数据就发起请求。

AsyncStorage 对外提供了简单的 [JavaScript](https://www.twle.cn/l/yufei/javascript/javascript-basic-index.html) 接口。每一个接口都是 **异步** 的，每一个接口都返回一个 `Promise` 对象。

## React Native 存储数据组件 AsyncStorage

### 安装组件

虽然之前的版本都是内置，但 0.60 版本将组件移到了 [react-native-community/react-native-async-storage](https://github.com/react-native-community/react-native-async-storage)。

为了兼容所有版本，我们推荐安装 [react-native-community/react-native-async-storage](https://github.com/react-native-community/react-native-async-storage)。

```
yarn add @react-native-community/async-storage
```

或

```
npm i @react-native-community/async-storage
```

### 链接组件

**React Native 0.60+ 版本会自动链接**。

但之前的版本则需要我们手动链接

```
react-native link @react-native-community/async-storage
```

如果你从低版本升级到 0.60+ 版本，反而要删除链接，命令如下

```
react-native unlink @react-native-community/async-storage
```

### 引入组件

```
import AsyncStorage from '@react-native-community/async-storage';
```

### 对外提供的方法

| 方法          | 说明                                              |
| ------------- | ------------------------------------------------- |
| getItem()     | 根据给定的 key 来读取数据                         |
| setItem()     | 将一个键值对添加到系统中，如果已经存在 key 则覆盖 |
| removeItem()  | 根据给定的 key 删除指定的键值对                   |
| getAllKeys()  | 返回数据库中所有的 **键**                         |
| multiGet()    | 根据给定的 key 列表获取多个键值对                 |
| multiSet()    | 将多个键值对存储到系统中                          |
| multiRemove() | 根据多个 key 删除多个键值对                       |
| clear()       | 清空整个数据库系统                                |

每一个接口的详细信息，可以 [官方 API 文档](https://github.com/react-native-community/async-storage)

### 使用示例

存储数据

```
storeData = async () => {
  try {
    await AsyncStorage.setItem('@storage_Key', 'stored value')
  } catch (e) {
    // 保存失败
  }
}
```

读取数据

```
getData = async () => {
  try {
    const value = await AsyncStorage.getItem('@storage_Key')
    if(value !== null) {
      // 之前存储的数据
    }
  } catch(e) {
    // 读取数据失败
  }
}
```

### 最佳实战

- 数据可能不存在，推荐在 `constructor()` 构造函数中先初始化一个默认值
- 推荐把读取数据的逻辑放到 `componentDidMount()` 中。

```react
import React from 'react'
import {Text, View, Alert, TextInput, StyleSheet, TouchableHighlight} from 'react-native'
import AsyncStorage from '@react-native-community/async-storage';

export default class App extends React.Component {

    state = {
        name: 'taoqz',
        intro: '我不想写前端'
    }

    async readData() {
        try {
            const value = await AsyncStorage.getItem('name')
            if (value != null) {
                this.setState({name: value})
            }
            Alert.alert('读取数据成功')
        } catch (e) {
            Alert.alert('读取数据失败')
        }
    }

    setName = () => {
        AsyncStorage.setItem('name', this.state.intro)
        Alert.alert('保存成功')
    }

    render() {
        return (
            <View style={styles.container}>
                <TextInput
                    style={styles.textInput}
                    autoCapitalize='none'
                    value={this.state.intro}/>
                <View style={{flexDirection: 'row'}}>
                    <TouchableHighlight style={[styles.button, {marginRight: 8}]} onPress={this.setName}>
                        <Text style={styles.buttonTxt}>保存</Text>
                    </TouchableHighlight>
                    <TouchableHighlight style={[styles.button, {backgroundColor: 'blue'}]}
                                        onPress={this.readData.bind(this)}>
                        <Text style={styles.buttonTxt}>读取</Text>
                    </TouchableHighlight>
                </View>
                <View style={{marginTop: 8}}>
                    <Text>当前的值：{this.state.name}</Text>
                </View>
            </View>
        )
    }

}

const styles = StyleSheet.create({
    container: {
        margin: 10
    },
    textInput: {
        margin: 5,
        height: 44,
        width: '100%',
        borderWidth: 1,
        borderColor: '#dddddd'
    },
    button: {
        flex: 1,
        height: 44,
        justifyContent: 'center',
        alignItems: 'center',
        width: 100,
        backgroundColor: 'red'
    },
    buttonTxt: {
        justifyContent: 'center',
        color: '#ffffff'
    }
})
```

## Picker选择器

```react
import React, {Component} from 'react';
import {View, Text, Picker, StyleSheet} from 'react-native'

class App extends Component {

    users = [
        {label: '请选择性别', value: ''},
        {label: '男', value: 'male'},
        {label: '女', value: 'female'},
        {label: '其它', value: 'other'}
    ]
    state = {user: ''}
    updateUser = (user) => {
        this.setState({user: user})
    }

    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.label}>请选择性别</Text>
                <Picker
                    selectedValue={this.state.user}
                    onValueChange={this.updateUser}>
                    {
                        this.users.map((o, index) =>
                            <Picker.Item label={o.label} value={o.value}/>
                        )
                    }
                </Picker>
                <Text style={styles.label}>你的选择是</Text>
                <Text style={styles.text}>{this.state.user}</Text>
            </View>
        )
    }
}

export default App

const styles = StyleSheet.create({

    container: {
        margin: 50,
    },
    label: {
        fontSize: 14,
        color: '#333333'
    },
    text: {
        fontSize: 30,
        alignSelf: 'center',
        color: 'red'
    }
})
```

## ScrollView下拉条

```react
import React, {Component} from 'react';
import {Text, View, ScrollView, StyleSheet} from 'react-native';

class App extends Component {
    state = {
        languages: [
            {'name': 'Python', 'id': 1},
            {'name': 'Perl', 'id': 2},
            {'name': 'PHP', 'id': 3},
            {'name': 'Ruby', 'id': 4},
            {'name': 'Scala', 'id': 5},
            {'name': 'JavaScript', 'id': 6},
            {'name': 'Rust', 'id': 7},
            {'name': 'Go', 'id': 8},
            {'name': 'Java', 'id': 9},
            {'name': 'C++', 'id': 10},
            {'name': 'C', 'id': 11},
            {'name': 'Awk', 'id': 12},
            {'name': 'Sed', 'id': 13},
            {'name': 'TypeScript', 'id': 14},
            {'name': 'C#', 'id': 15},
            {'name': 'F#', 'id': 16},
            {'name': 'CSS', 'id': 17},
            {'name': 'HTML', 'id': 18},
            {'name': 'React Native', 'id': 19}
        ]
    }

    render() {
        return (
            <View style={styles.list}>
                {/*效果是右侧有下拉条*/}
                <ScrollView>
                    {
                        // 使用map迭代数据,需要提供key,但不推荐使用index,在React笔记中有做记录
                        this.state.languages.map((item, index) => (
                            <View key={item.id} style={styles.item}>
                                <Text>{item.name}</Text>
                            </View>
                        ))
                    }
                </ScrollView>
            </View>
        )
    }
}

export default App

const styles = StyleSheet.create({

    list: {
        backgroundColor: '#eeeeee',
    },
    item: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: 30,
        marginBottom: 8,
        backgroundColor: '#ffffff'
    }
})
```

## Switch开关按钮

```react
import React from 'react'
import {Text, Alert, View, Switch, StyleSheet, TouchableOpacity,} from 'react-native'

export default class App extends React.Component {

    state = {
        switchState: {
            true: '开',
            false: '关'
        },
        defaultState: false
    };

    changeSwitch = () => {
        const flag = this.state.defaultState;
        this.setState({defaultState: !flag})
    }

    render() {
        return (
            <View style={styles.container}>
                <Switch
                    // 开关 默认false 关闭
                    value={this.state.defaultState}
                    // 开关改变时触发方法
                    onChange={this.changeSwitch}
                    // 按钮圆点的颜色
                    thumbColor={'red'}
                    // 按钮框的颜色 可以分别制定开和关时的颜色
                    trackColor={{false: 'pink', true: 'green'}}
                />
                <Text>当前Switch的状态:{this.state.switchState[this.state.defaultState]}</Text>
            </View>
        )
    }

}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center',
        marginTop: 300
    }
})
```

## TextInput输入框

```react
import React from 'react'
import {View, Text, TouchableOpacity, TextInput, StyleSheet} from 'react-native'

export default class Inputs extends React.Component {

    // 定义对象,包含邮件,密码及备注信息
    state = {
        email: '',
        password: '',
        remark: ''
    }

    // 输入框输入值后调用方法设置值
    handleEmail = (text) => {
        this.setState({email: text})
    }

    handlePwd = (text) => {
        this.setState({password: text})
    }

    handleRemark = (text) => {
        this.setState({remark: text})
    }

    // 注册方法
    register = (email, password, remark) => {
        alert('您的邮箱是:' + email + " 您的密码是:" + password + " 您的备注信息:" + remark)
    }

    render() {
        return (

            <View style={styles.container}>
                <TextInput
                    style={styles.input}
                    // Android中下划线的颜色,透明则为transparent
                    underlineColorAndroid="transparent"
                    // 占位符
                    placeholder="请输入邮箱"
                    // 占位符的颜色
                    placeholderTextColor="#ccc"
                    // 字母大写模式
                    autoCapitalize="none"
                    // 键盘类型
                    keyboardType="email-address"
                    // 键盘上返回键的类型
                    returnKeyType="next"
                    onChangeText={this.handleEmail}
                />
                <TextInput
                    style={styles.input}
                    underlineColorAndroid="transparent"
                    placeholder="请输入密码"
                    placeholderTextColor="#ccc"
                    autoCapitalize="none"
                    returnKeyType="next"
                    secureTextEntry={true}
                    onChangeText={this.handlePwd}/>

                <TextInput
                    style={[styles.input, {height: 100}]}
                    underlineColorAndroid="transparent"
                    placeholder="请输入描述"
                    placeholderTextColor="#ccc"
                    autoCapitalize="none"
                    multiline={true}
                    numberOfLines={4}
                    textAlignVertical="top"
                    returnKeyType="done"
                    onChangeText={this.handleRemark}/>


                <TouchableOpacity
                    style={styles.submitButton}
                    onPress={
                        () => this.register(this.state.email, this.state.password, this.state.remark)
                    }>
                    <Text style={styles.submitButtonText}>注册</Text>
                </TouchableOpacity>

            </View>

        )
    }


}

const styles = StyleSheet.create({
    container: {
        paddingTop: 23
    },
    input: {
        margin: 15,
        paddingLeft: 8,
        height: 40,
        borderColor: '#eeeeee',
        borderWidth: 1
    },
    submitButton: {
        backgroundColor: '#7a42f4',
        padding: 10,
        alignItems: 'center',
        margin: 15,
        height: 40,
    },
    submitButtonText: {
        color: 'white'
    }
})
```

## SectionList带标题的下拉列表

```react
import React, {Component} from 'react';
import {SectionList, StyleSheet, Text, View} from 'react-native';

/**
 * 带标题的列表
 */
export default class SectionListBasics extends Component {
    render() {
        return (
            <View style={styles.container}>
                <SectionList
                    sections={[
                        {title: 'D', data: ['Devin', 'Dan', 'Dominic']},
                        {title: 'J', data: ['Jackson', 'James', 'Jillian', 'Jimmy', 'Joel', 'John', 'Julie']},
                    ]}
                    renderItem={({item}) => <Text style={styles.item}>{item}</Text>}
                    renderSectionHeader={({section}) => <Text style={styles.sectionHeader}>{section.title}</Text>}
                    // keyExtractor={(item, index) => index}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        paddingTop: 22,
    },
    sectionHeader: {
        paddingTop: 2,
        paddingLeft: 10,
        paddingRight: 10,
        paddingBottom: 2,
        fontSize: 14,
        fontWeight: 'bold',
        backgroundColor: 'rgba(247,247,247,1.0)',
    },
    item: {
        padding: 10,
        fontSize: 18,
        height: 44,
    },
});
```

## 功能组件

```react
import React from 'react';
import {View, Text, TextInput} from 'react-native';

export default function print() {
    function getFullName(firstName, lastName) {
        return firstName + ' ' + lastName;
    }

    return (
        <View>
            <Text>
                我是功能组件!!! {getFullName('Tao', 'zzz')}
            </Text>

            <TextInput
                style={{
                    height: 40,
                    borderColor: 'gray',
                    borderWidth: 1,
                }}
                defaultValue="Name me!"
            />

        </View>
    );
}
```

## ImageBackgroud

```react
<ImageBackground
    source={require('../img/header.jpg')}
    style={{height: 300, width: 300}}
    // resizeMode={"center"}
    >
    <Text style={{color:'white',textAlign: 'center'}}>
        Hello!!!
    </Text>
</ImageBackground>
```



## 发送请求

其中fetch和XMLHttpRequest是自带的,如果使用axios,需要安装并且引入。

```shell
# 两种安装方式
yarn add axios
npm install axios
```

```react
import React, {Component} from 'react';
// 引入axios
import axios from 'axios';
import {View, Text} from 'react-native';

export default class App extends Component {

    // 设置一个状态变量,用于显示数据
    state = {
        msg: 'init',
    };
    
    // 使用fetch发送请求
    getMoviesFromApiAsync = () => {
        console.log('发送请求!!!');
        // return fetch('https://reactnative.dev/movies.json', {
        return fetch('http://192.168.0.199:8080/hello', {
            method: 'GET',
            cache: 'no-cache',
        })
        // 用于指定返回的数据的类型
            .then((response) => response.json())
            .then((responseJson) => {
                this.setState({msg: responseJson.msg + '!'});
                console.log(responseJson);
                return responseJson;
            })
            .catch((error) => {
                console.error(error);
                console.log('出错了');
            });
    };

    // 使用原生XMLHttpRequest对象发送请求
    sendAjax = () => {
        const request = new XMLHttpRequest();
        request.onreadystatechange = (e) => {
            if (request.readyState !== 4) {
                return;
            }

            if (request.status === 200) {
                // 返回的数据是一个JSON字符串将其转换为对象,方便获取数据
                console.log('success', request.responseText);
                this.setState({msg: JSON.parse(request.responseText).msg});
            } else {
                console.warn('error');
            }
        };

        request.open('GET', 'http://192.168.0.199:8080/hello');
        request.send();
    };
    
    // 使用axios发送请求
    sendAxios = () => {
        // const axios = require('axios');
        axios.get('http://192.168.0.199:8080/hello')
            .then(res => {
                console.log(res.data);
                this.setState({msg: res.data.msg + '!!'});
            })
            // 状态码500 返回的数据
            .catch((error) => {
                console.log(error.response.data.msg);
            });
    };

    // 使用axios发送异步请求,,同样fetch也支持异步请求
    async sendAsyncAxios() {
        try {
            let {data} = await axios.get('http://192.168.0.199:8080/hello');
            console.log('hello:', data);
            // 可以直接使用this
            this.setState({msg:data.msg})
        } catch (e) {
            console.log(e);
        }
    }

	// 页面渲染后调用,也就是在render执行后在调用
    componentDidMount = () => {
        // this.getMoviesFromApiAsync()
        // this.sendAjax();
        // this.sendAxios();
        this.sendAsyncAxios();
    };

    render() {

        return (
            <View>
                <Text>
                    {this.state.msg}
                </Text>
            </View>
        );
    }
}
```



## 遇到的问题

### 发送请求

再使用真机和Android Studio提供的模拟机时发送请求会出现network request failed问题,在夜神模拟器上解决了该问题,原因可能是因为安卓的版本问题,真机和模拟机使用的9,而夜神模拟器使用的版本是5。



































