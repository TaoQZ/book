# springcloud使用原生websocket



## pom依赖

```xml
    <!-- websocket -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-websocket</artifactId>
    </dependency>
```

```java
@Configuration
public class WebSocketConfig {
    @Bean
    public ServerEndpointExporter serverEndpointExporter() {
        return new ServerEndpointExporter();
    }
}
```

```java
package com.parkride.system.config;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.parkride.system.chat.ChatMessage;
import com.parkride.system.chat.Requests;
import com.parkride.system.service.ChatService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
@ServerEndpoint("/websocket/{userId}") // 前端直接 ws://host/websocket/123
public class WebSocketServer {

    private static ChatService chatService;

    @Resource
    public void setChatService(ChatService chatService) {
        WebSocketServer.chatService = chatService;
    }

    private static final ConcurrentHashMap<String, Session> sessionMap = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, @PathParam("userId") String userId) {
        log.info("客户端已连接 userId: {} , sessionId: {}", userId, session.getId());
        sessionMap.put(userId, session);
    }

    @OnMessage
    public void onMessage(String message, @PathParam("userId") String userId) {
        try {
            log.info("message: {}", message);
            if (ChatMessage.MessageType.CHAT_MESSAGE.name().equalsIgnoreCase(JSONObject.parseObject(message).getString("type"))) {
                Requests.SendMessageReq req = JSON.parseObject(message, Requests.SendMessageReq.class);
                ChatMessage savedMsg = chatService.sendMessage(req);
                sendMessage(req.getReceiverId(), JSON.toJSONString(savedMsg));
            }
        } catch (Exception e) {
            log.error("onMessage: {}", e.getMessage());
        }
    }

    @OnClose
    public void onClose(Session session, @PathParam("userId") String userId) {
        sessionMap.remove(userId);
        chatService.closeSession(Long.parseLong(userId));
    }

    @OnError
    public void onError(Session session, Throwable error, @PathParam("userId") String userId) {
        System.out.println("用户错误: " + userId + " error=" + error.getMessage());
    }

    public static void sendMessage(String userId, String message) {
        Session session = sessionMap.get(userId);
        if (session != null && session.isOpen()) {
            session.getAsyncRemote().sendText(message);
        }
    }
}

```

## 测试连接

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>

<script>
    // 创建连接
    const socket = new WebSocket("ws://10.40.11.52:11110/websocket/12334");

    // 连接成功
    socket.onopen = function () {
        console.log("✅ WebSocket 已连接");

        // 直接发送消息（字符串或JSON）
        socket.send(JSON.stringify({
            receiverId: '111',
            senderType: 'AGENT',
            senderId: '1',
            senderName: '客服1',
            contentType: 'TEXT',
            sessionId: "1",
            content: "content",
            timestamp: new Date().toISOString()
        }));
    };

    // 接收消息
    socket.onmessage = function (event) {
        console.log("📩 收到消息:", event.data);
    };

    // 连接关闭
    socket.onclose = function () {
        console.log("❌ WebSocket 已关闭");
    };

    // 出错
    socket.onerror = function (error) {
        console.error("⚠️ WebSocket 出错:", error);
    };

</script>
<body>

</body>
</html>

```

## 重要问题

websocket服务没有写在网关里，而是别的服务里，但是连接要通过网关连接，下面是主要配置

```yaml
cloud:
gateway:
  discovery:
    locator:
      lowerCaseServiceId: true
      enabled: true
  routes:
    # WebSocket 转发
    - id: websocket_route
      uri: ws://ip:11103
      predicates:
        - Path=/websocket/** 
```

## 如果有做白名单的功能

```yaml
- /websocket/**
```

