springboot+vue+websocket

环境
java: 1.8
springboot: 2.3.4.RELEASE

所需依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-websocket</artifactId>
</dependency>
<!--主用日志-->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
</dependency>
```

WebSocketServer

其中会维护一个键值对,键可以通过session中的属性设置,value存session,利用该session进行推送消息

```java
package xyz.taoqz.component;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author taoqz
 */
@ServerEndpoint(value = "/websocket")
@Component
@Slf4j
public class WebSocketServer {

    @PostConstruct
    public void init() {
    }

    private static final AtomicInteger ONLINE_COUNT = new AtomicInteger(0);
    /**
     * concurrent包的线程安全Set，用来存放每个客户端对应的Session对象。
     */
    private static final CopyOnWriteArraySet<Session> SESSION_SET = new CopyOnWriteArraySet<>();
    private static final ConcurrentHashMap<String, Session> SESSION_MAP = new ConcurrentHashMap<>();

    /**
     * 连接建立成功调用的方法
     */
    @OnOpen
    public void onOpen(Session session) {
        String host = session.getRequestURI().getHost();
        //        SESSION_MAP.put("192.168.1.142", session);
        SESSION_MAP.put(host, session);
        SESSION_SET.add(session);
        // 在线数加1
        int cnt = ONLINE_COUNT.incrementAndGet();
        log.info("有连接加入，当前连接数为：{}", cnt);
        sendMessage(session, "连接成功");
    }

    /**
     * 连接关闭调用的方法
     */
    @OnClose
    public void onClose(Session session) {
        SESSION_SET.remove(session);
        SESSION_MAP.remove(session.getRequestURI().getHost());
        int cnt = ONLINE_COUNT.decrementAndGet();
        log.info("有连接关闭，当前连接数为：{}", cnt);
    }

    /**
     * 收到客户端消息后调用的方法
     *
     * @param message 客户端发送过来的消息
     */
    @OnMessage
    public void onMessage(String message, Session session) {
        log.info("来自客户端的消息：{}", message);
        sendMessage(session, "收到消息，消息内容：" + message);

    }

    /**
     * 出现错误
     *
     * @param session session 对象
     * @param error   错误信息
     */
    @OnError
    public void onError(Session session, Throwable error) {
        log.error("发生错误：{}，Session ID： {}", error.getMessage(), session.getId());
        error.printStackTrace();
    }

    /**
     * 发送消息，实践表明，每次浏览器刷新，session会发生变化。
     *
     * @param session session 对象
     * @param message 消息
     */
    public void sendMessage(Session session, String message) {
        try {
            session.getBasicRemote().sendText(message);
        } catch (IOException e) {
            log.error("发送消息出错：{}", e.getMessage());
            e.printStackTrace();
        }
    }

    public void sendMessageByHost(String host, String message) {
        try {
            Session session = SESSION_MAP.get(host.replace("http://", ""));
            if (session.isOpen()) {
                session.getBasicRemote().sendText(message);
            } else {
                SESSION_MAP.remove(host);
                log.error("该session已关闭！");
            }
        } catch (Exception e) {
            log.error("发送消息出错：{}", e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 群发消息
     *
     * @param message 消息
     */
    public void broadCastInfo(String message) {
        for (Session session : SESSION_SET) {
            if (session.isOpen()) {
                sendMessage(session, message);
            }
        }
    }

    /**
     * 指定Session发送消息
     *
     * @param sessionId sessionId
     * @param message   message
     */
    public void sendMessage(String sessionId, String message) throws IOException {
        Session session = null;
        for (Session s : SESSION_SET) {
            if (s.getId().equals(sessionId)) {
                session = s;
                break;
            }
        }
        if (session != null) {
            sendMessage(session, message);
        } else {
            log.warn("没有找到你指定ID的会话：{}", sessionId);
        }
    }
}
```

WebSocketConfig

```java
package xyz.taoqz.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.server.standard.ServerEndpointExporter;

/**
 * @author waver
 */
@Configuration
public class WebSocketConfig {
    /**
     * 给spring容器注入这个ServerEndpointExporter对象
     * 相当于xml：
     * <beans>
     * <bean id="serverEndpointExporter" class="org.springframework.web.socket.server.standard.ServerEndpointExporter"/>
     * </beans>
     * <p>
     * 检测所有带有@serverEndpoint注解的bean并注册他们。
     *
     * @return ServerEndpointExporter
     */
    @Bean
    public ServerEndpointExporter serverEndpointExporter() {
        return new ServerEndpointExporter();
    }
}
```

vue所需内容

下载依赖

```shell
npm install vue-native-websocket
```

导包

```js
import VueNativeSock from 'vue-native-websocket'
// 这里的地址,写后端的全路径
Vue.use(VueNativeSock, 'ws://localhost:8989/resourcenter/websocket', {
    connectManually: true
})
```

使用

```java
webSocketMessage(host) {
    // 这里的host需要和后端中session的key设置为相同的属性  
    let wsServer = host.replace('http://', 'ws://')
        console.log(wsServer + this.websocketURL)
        // 开启连接
        this.$connect(wsServer + this.websocketURL, {format: 'json'}) 
        // 接收消息
        this.$options.sockets.onmessage = function (msg) {
        if (msg.data === '连接成功') {
            console.log(msg.data)
        } else {
            this.$message.success(msg.data)
        }
    }
}
```

