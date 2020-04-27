# Navigation导航组件

官方文档:https://reactnavigation.org/docs/getting-started

## 安装

```shell
yarn add @react-navigation/native

yarn add react-native-reanimated react-native-gesture-handler react-native-screens react-native-safe-area-context @react-native-community/masked-view
```

## 案例

```react
import * as React from 'react';
import 'react-native-gesture-handler';
import {View, Text, Button} from 'react-native';
import {NavigationContainer} from '@react-navigation/native';
import {createStackNavigator} from '@react-navigation/stack';

function HomeScreen({navigation}) {
    return (
        <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
            <Text>
                Home Screen
            </Text>
            {/*点击跳转至详情页面*/}
            {/*组件进行跳转后,默认会在左上角显示退回标记*/}
            <Button
                title='Go to details'
                onPress={() => navigation.navigate('Detail')}
            />
        </View>
    );
}

function DetailsScreen({navigation}) {
    return (
        <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
            <Text>Details Screen</Text>
            {/*如果在本页面进行跳转不会发生任何改变*/}
            <Button
                title='Go to Detail 没有效果'
                onPress={() => navigation.navigate('Detail')}
            />

            <Button
                title='Go to details 该方式无论如何都会跳转'
                // 必须和Stack.Screen中的name属性相同
                onPress={() => navigation.push('Detail')}
            />
            <Button
                title='Go to Home'
                onPress={() => navigation.navigate('Home')}
            />
            {/*使用编程的方式退回*/}
            <Button
                title='Go Back 手动返回'
                onPress={() => navigation.goBack()}
            />

            {/*返回在该次跳转屏幕的列表中的第一个*/}
            <Button
                title='Go to first stack in screen'
                onPress={() => navigation.popToTop()}
            />
        </View>
    );

}

// 其中Stack的名字可以自定义
const Stack = createStackNavigator();

export default function App() {
    return (
        <NavigationContainer>
            {/*指定初始页面*/}
            {/*默认会按照顺序进行第一个的显示*/}
            <Stack.Navigator initialRouteName='Home'>

                {/*name是页面的标题 component是具体的组件*/}
                <Stack.Screen name='Home' component={HomeScreen}/>

                {/*可以使用title替换name显示的标题*/}
                <Stack.Screen
                    name='Detail'
                    component={DetailsScreen}
                    options={{title: '详情信息'}}
                />
            </Stack.Navigator>
        </NavigationContainer>
    );
}
```

## 导航传值

```react
import React from 'react';
import 'react-native-gesture-handler';
import {View, Text, Button} from 'react-native';
import {createStackNavigator} from '@react-navigation/stack';
import {NavigationContainer} from '@react-navigation/native';

function HomeScreen({navigation}) {
    return (
        <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
            <Text>
                Home Screen
            </Text>
            <Button
                title='Go to Detail'
                onPress={() => {
                    navigation.navigate('Detail', {
                        id: 666,
                        // name: 'zs'
                    });
                }}
            />
        </View>
    );
}

function DetailScreen({route}) {
    return (
        <View>
            <Text>
                {route.params.id}
            </Text>
            <Text>
                {route.params.name}
            </Text>
        </View>
    );
}

// 创建视窗对象
const Stack = createStackNavigator();

export default function App() {
    return (
        <NavigationContainer>
            <Stack.Navigator>
                <Stack.Screen
                    name='Home'
                    component={HomeScreen}
                    options={{title: '首页'}}
                />

                <Stack.Screen
                    name='Detail'
                    component={DetailScreen}
                    options={{title: '详情'}}
                    // 可以添加默认参数,如果上一个组件跳转时没有传递数据,默认使用该数据,如果传递了数据,会进行相应的覆盖
                    initialParams={{id: 1, name: 'list'}}
                />
            </Stack.Navigator>
        </NavigationContainer>
    );
}
```

### 导航之间向上传值

```react
import React from 'react';
import 'react-native-gesture-handler';
import {View, Text, Button, TextInput} from 'react-native';
import {createStackNavigator} from '@react-navigation/stack';
import {NavigationContainer} from '@react-navigation/native';


function HomeScreen({navigation, route}) {
    return (
        <View>
            <Text>
                Home
            </Text>
            <Text>
                新添加的数据:{route.params?.post}
            </Text>

            {/*创建一个按钮用于跳转页面*/}
            <Button
                title='Go to Post'
                onPress={() => {
                    navigation.navigate('CreatePost');
                }}
            />
        </View>
    );
}

function CreatePost({navigation}) {

    // 使用Hooks新特性创建一个状态
    const [postText, setPostText] = React.useState('');

    return (
        <View>
            <TextInput
                multiline
                placeholder="What's on your mind?"
                style={{height: 200, padding: 10, backgroundColor: 'white'}}
                value={postText}
                onChangeText={setPostText}
            />

            <Button
                title='Done'
                onPress={() => {
                    navigation.navigate('Home', {post: postText});
                }}
            />
        </View>
    );
}

const Stack = createStackNavigator();

export default function App() {
    return (
        <NavigationContainer>
            <Stack.Navigator>
                <Stack.Screen
                    name='Home'
                    component={HomeScreen}
                    options={{title: '主页'}}
                />
                <Stack.Screen
                    name='CreatePost'
                    component={CreatePost}
                    options={{title: '新建'}}
                />
            </Stack.Navigator>
        </NavigationContainer>
    );
}
```

## 设置导航的样式

## 在标题上使用导航传递的值

```react
import React from 'react';
import 'react-native-gesture-handler';
import {View, Text, Button, StyleSheet} from 'react-native';
import {NavigationContainer} from '@react-navigation/native';
import {createStackNavigator} from '@react-navigation/stack';

function HomeScreen({navigation}) {
    return (
        <View style={styles.myCenter}>
            <Text>
                Home
            </Text>
            <Button
                title='Go to Profile'
                onPress={() => {
                    // navigation.navigate('Profile')
                    navigation.navigate('Profile', {title: '我是通过首页传递过来的Title'});
                }}
            />
        </View>
    );
}

function Proflie({navigation, route}) {
    return (
        <View style={styles.myCenter}>
            <Text>
                Profile
            </Text>
            <Text>
                {route.params.title}
            </Text>

            {/*使用编程的方式更新title*/}
            <Button
                title='update this button title'
                onPress={() => {
                    navigation.setOptions({
                        title: 'new title',
                        // 设置标题背景颜色
                        headerStyle: {
                            backgroundColor: 'green',
                        },
                        // 设置标题文字和返回按钮的颜色
                        headerTintColor: 'yellow',
                        // 设置标题文字的样式
                        headerTitleStyle: {
                            // fontSize: 10,
                            fontFamily: 'cursive',
                        },
                    });
                }}
            />
        </View>
    );
}

const Stack = createStackNavigator();
export default function StackScreen() {
    return (
        <NavigationContainer>
            <Stack.Navigator>
                <Stack.Screen
                    name='Home'
                    component={HomeScreen}
                    options={{
                        title: '首页',
                        headerStyle: {
                            backgroundColor: 'red',
                        },
                    }}
                />
                <Stack.Screen
                    name='Profile'
                    component={Proflie}
                    // options={{title: 'profiles'}}
                    // 将传递的参数作为新的标题
                    options={({route}) => ({title: route.params.title})}
                />
            </Stack.Navigator>
        </NavigationContainer>
    );

}

const styles = StyleSheet.create({
    myCenter: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
    },
});

```

## 使用自定义组件作为导航的样式

```react
import React from 'react';
import 'react-native-gesture-handler';
import {Image, Text, View, Button} from 'react-native';
import {NavigationContainer} from '@react-navigation/native';
import {createStackNavigator} from '@react-navigation/stack';


function LogoTitle() {
    return (
        <View>
            <Image
                style={{width: 50, height: 50}}
                source={require('../img/header.jpg')}
            />
            <Text>
                自定义标题内容
            </Text>
        </View>
    );
}

function HomeScreen({navigation}) {
    return (
        <View>
            <Text>
                Home
            </Text>
            <Button
                title='Go to Detail'
                onPress={() => {
                    navigation.navigate('Detail')
                }}
            />
        </View>
    );
}

function DetailScreen() {
    return (
        <View>
            <Text>
                Detail
            </Text>
        </View>
    );
}

const Stack = createStackNavigator();

export default function StackScreen() {
    return (
        <NavigationContainer>
            <Stack.Navigator>
                <Stack.Screen
                    name="Home"
                    component={HomeScreen}
                />

                <Stack.Screen
                    name="Detail"
                    component={DetailScreen}
                    // 引用指定的组件作为标题返回箭头后的样式
                    options={{
                        headerTitle: props =>
                            <LogoTitle {...props} />
                    }}
                />
            </Stack.Navigator>
        </NavigationContainer>
    );
}
```

屏幕之间共享标题的样式

Stack.Navigator组件的screenOptions属性

```react
import React from 'react';
import 'react-native-gesture-handler';
import {View, Text, Button, StyleSheet} from 'react-native';
import {createStackNavigator} from '@react-navigation/stack';
import {NavigationContainer} from '@react-navigation/native';

// 解决多个navigator需要使用同一个样式的情况 也就是共享标题
function HomeScreen({navigation}) {
    return (
        <View>
            <Text>
                Home
            </Text>

            <Button
                title='Go to Others Navigation'
                onPress={() => {
                    navigation.navigate('Others');
                }}
            />
        </View>
    );
}

function Others({navigation}) {
    return (
        <View>
            <Text>
                Others
            </Text>
            <Button
                title='Go to Others Navigation'
                onPress={() => {
                    navigation.navigate('Three');
                }}
            />
        </View>
    );
}

function Three() {
    return (
        <View>
            <Text>
                Three
            </Text>
        </View>
    );
}

const Stack = createStackNavigator();

export default function App() {
    return (
        <NavigationContainer>

            {/*在该标签的screenOptions属性中 为所有的navigator设置统一的标题样式*/}
            <Stack.Navigator
                screenOptions={{
                    headerStyle: {
                        backgroundColor: 'red',
                    },
                    headerTintColor: 'green',
                }}
            >
                <Stack.Screen
                    name='Home'
                    component={HomeScreen}
                />
                <Stack.Screen
                    name='Others'
                    component={Others}
                />

                <Stack.Screen
                    name='Three'
                    component={Three}
                />
            </Stack.Navigator>
            {/*<Stack.Navigator>*/}
            {/*   */}
            {/*</Stack.Navigator>*/}
        </NavigationContainer>

    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
    },
});
```

## 右侧跳转,组件封装

```react
import React from 'react';
import 'react-native-gesture-handler';
import {View, Text} from 'react-native';

export default function RightScreen() {
    return (
        <View>
            <Text>
                RightScreen
            </Text>
        </View>
    );
}
```

```react
import React, {Component} from 'react';
import 'react-native-gesture-handler';
import {View, Text, Button} from 'react-native';
import {createStackNavigator} from '@react-navigation/stack';
import {NavigationContainer} from '@react-navigation/native';
import RightScreen from './RightScreen';

function HomeScreen() {
    return (
        <View>
            <Text>
                Home
            </Text>
        </View>
    );
}

const Stack = createStackNavigator();

export default function App() {
    return (
        <NavigationContainer>
            <Stack.Navigator>
                <Stack.Screen
                    name='Home'
                    component={HomeScreen}
                    options={({navigation, route}) => ({
                        headerRight: () => (
                            <Button
                                title='Right'
                                onPress={() => {
                                    navigation.navigate('Right');
                                    // alert('this is a button')
                                }}
                            />
                        ),
                    })}

                />
                <Stack.Screen
                    name='Right'
                    component={RightScreen}
                />
            </Stack.Navigator>
        </NavigationContainer>
    );
}
```

