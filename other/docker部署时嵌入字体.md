之前做的一个需求，根据用户名默认生成头像，类似钉钉的那种。经调试后本地windows没问题，发布到测试环境不好使，经排查是因为使用的docker部署，导致容器内没有相关的字体文件，以下是解决方案。

```dockerfile
FROM openjdk:17
# 作者信息
MAINTAINER tao


# 创建字体目录
RUN mkdir -p /usr/share/fonts/chinese
# 复制字体文件到容器中，其中 fonts/simsun.ttc 文件是在宿主机下的文件
COPY fonts/simsun.ttc /usr/share/fonts/chinese/simsun.ttc
# 更新字体缓存
RUN fc-cache -fv
# 验证字体是否安装成功
RUN fc-list :lang=zh

#修改镜像为东八区时间
ENV TZ Asia/Seoul
VOLUME /tmp
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
EXPOSE 10102
ENV JAVA_OPTS="-server"
ENTRYPOINT java -Djdk.certpath.disabledAlgorithms=MD2  -jar /app.jar
```

