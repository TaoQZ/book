# kafka搭建集群

## 环境

```shell
CentOS Linux release 7.3.1611 (Core)
java version "1.8.0_321"
kafka_2.12-2.7.0(使用了内置的zookeeper)
```

## kafka下载地址

https://kafka.apache.org/downloads

## 解压安装包

```bash
tar zxvf kafka_2.12-2.7.0.tgz
```

## 目录结构

| 目录名称  | 说明                               |
| :-------: | ---------------------------------- |
|    bin    | kafka所有的执行脚本                |
|  config   | kafak所有的配置文件(包括zookeeper) |
|   logs    | kafka所有日志文件                  |
|   libs    | kafka所依赖的所有jar包             |
| site-docs | 使用说明文档                       |



## 安装配置

### 创建日志文件夹

目的：因为日志默认是存在/tmp 下，重新启动后会消失

```shell
kafka日志文件：/home/app/kafka/kafka_2.12-2.7.0/log/kafka
zookeeper日志文件：/home/app/kafka/kafka_2.12-2.7.0/log/zookeeper
```

### 创建zookeeper数据文件夹

```shell
/home/app/kafka/kafka_2.12-2.7.0/zkData
```

### 在zookeeper数据文件夹中创建文件

```shell
# 其中 1 则是每个服务器的id,不可重复
cd /home/app/kafka/kafka_2.12-2.7.0/zkData
echo 1 > myid
```

### 修改zookeeper配置文件

zookeeper.properties

![image-20220329173456421](./kafka搭建集群.assets\image-20220329173456421.png)

#### 修改或添加项

```shell
# 数据目录，对应新创建的数据目录
dataDir=/home/app/kafka/kafka_2.12-2.7.0/zkData
# 日志目录，对应新创建的目录
dataLogDir=/home/app/kafka/kafka_2.12-2.7.0/log/zookeeper
# 注释该行
# maxClientCnxns=0

# 设置连接参数，添加如下配置　　　　
# 为zk的基本时间单元，毫秒
tickTime=2000
# Leader-Follower初始通信时限 tickTime*10
initLimit=10
# Leader-Follower同步通信时限 tickTime*5
syncLimit=5
# 设置broker Id的服务地址（修改对应服务器ip即可）
# 其中server.0 server.1 server.2 后的 0 1 2 也是对应zookeeper数据目录zkData下myid文件中的内容
server.0=192.168.92.128:2888:3888
server.1=192.168.92.129:2888:3888
server.2=192.168.92.130:2888:3888
```



### 修改kafka配置文件

server.properties

![image-20220329174012205](./kafka搭建集群.assets\image-20220329174012205.png)

#### 修改或添加项

```shell
# broker 的全局唯一编号，不能重复，对应 zkData中myid的值
broker.id=0
# 配置监听，修改位本机ip
listeners=PLAINTEXT://192.168.92.128:9092
advertised.listeners=PLAINTEXT://192.168.92.128:9092
# 修改输出日志文件位置
log.dirs=/home/app/kafka/kafka_2.12-2.7.0/log/kafka
# 配置三台zookeeper地址
zookeeper.connect=192.168.92.128:2181,192.168.92.129:2181,192.168.92.130:2181
```

## 启动

需要先启动zookeeper,等zookeeper启动完成后启动kafka

### 启动zookeeper

```shell
# 当前命令行启动
./bin/zookeeper-server-start.sh ./config/zookeeper.properties &
# 后台启动
nohup ./bin/zookeeper-server-start.sh ./config/zookeeper.properties > ./log/zookeeper/zookeeper.log 2>1 &
```

### 启动kafka

```shell
# 当前命令行启动
./bin/kafka-server-start.sh ./config/server.properties &
# 后台启动
nohup ./bin/kafka-server-start.sh ./config/server.properties > ./log/kafka/kafka.log 2>1 &
```



## 修改后完整配置文件

### zookeeper.properties

```shell
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# the directory where the snapshot is stored.
dataDir=/home/app/kafka/kafka_2.12-2.7.0/zkData
dataLogDir=/home/app/kafka/kafka_2.12-2.7.0/log/zookeeper
# the port at which the clients will connect
clientPort=2181
# disable the per-ip limit on the number of connections since this is a non-production config
# maxClientCnxns=0
# Disable the adminserver by default to avoid port conflicts.
# Set the port to something non-conflicting if choosing to enable this
admin.enableServer=false
# admin.serverPort=8080
# 设置连接参数，添加如下配置　　　　
# 为zk的基本时间单元，毫秒
tickTime=2000
# Leader-Follower初始通信时限 tickTime*10
initLimit=10
# Leader-Follower同步通信时限 tickTime*5
syncLimit=5
# 设置broker Id的服务地址
server.0=192.168.92.128:2888:3888
server.1=192.168.92.129:2888:3888
server.2=192.168.92.130:2888:3888
```



### server.properties

```shell
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# see kafka.server.KafkaConfig for additional details and defaults

############################# Server Basics #############################

# The id of the broker. This must be set to a unique integer for each broker.
broker.id=0

############################# Socket Server Settings #############################

# The address the socket server listens on. It will get the value returned from 
# java.net.InetAddress.getCanonicalHostName() if not configured.
#   FORMAT:
#     listeners = listener_name://host_name:port
#   EXAMPLE:
#     listeners = PLAINTEXT://your.host.name:9092
#listeners=PLAINTEXT://:9092
listeners=PLAINTEXT://192.168.92.128:9092

# Hostname and port the broker will advertise to producers and consumers. If not set, 
# it uses the value for "listeners" if configured.  Otherwise, it will use the value
# returned from java.net.InetAddress.getCanonicalHostName().
#advertised.listeners=PLAINTEXT://your.host.name:9092
# 配置监听，修改位本机ip
advertised.listeners=PLAINTEXT://192.168.92.128:9092

# Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
#listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL

# The number of threads that the server uses for receiving requests from the network and sending responses to the network
num.network.threads=3

# The number of threads that the server uses for processing requests, which may include disk I/O
num.io.threads=8

# The send buffer (SO_SNDBUF) used by the socket server
socket.send.buffer.bytes=102400

# The receive buffer (SO_RCVBUF) used by the socket server
socket.receive.buffer.bytes=102400

# The maximum size of a request that the socket server will accept (protection against OOM)
socket.request.max.bytes=104857600


############################# Log Basics #############################

# A comma separated list of directories under which to store log files
log.dirs=/home/app/kafka/kafka_2.12-2.7.0/log/kafka

# The default number of log partitions per topic. More partitions allow greater
# parallelism for consumption, but this will also result in more files across
# the brokers.
num.partitions=1

# The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
# This value is recommended to be increased for installations with data dirs located in RAID array.
num.recovery.threads.per.data.dir=1

############################# Internal Topic Settings  #############################
# The replication factor for the group metadata internal topics "__consumer_offsets" and "__transaction_state"
# For anything other than development testing, a value greater than 1 is recommended to ensure availability such as 3.
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1

############################# Log Flush Policy #############################

# Messages are immediately written to the filesystem but by default we only fsync() to sync
# the OS cache lazily. The following configurations control the flush of data to disk.
# There are a few important trade-offs here:
#    1. Durability: Unflushed data may be lost if you are not using replication.
#    2. Latency: Very large flush intervals may lead to latency spikes when the flush does occur as there will be a lot of data to flush.
#    3. Throughput: The flush is generally the most expensive operation, and a small flush interval may lead to excessive seeks.
# The settings below allow one to configure the flush policy to flush data after a period of time or
# every N messages (or both). This can be done globally and overridden on a per-topic basis.

# The number of messages to accept before forcing a flush of data to disk
#log.flush.interval.messages=10000

# The maximum amount of time a message can sit in a log before we force a flush
#log.flush.interval.ms=1000

############################# Log Retention Policy #############################

# The following configurations control the disposal of log segments. The policy can
# be set to delete segments after a period of time, or after a given size has accumulated.
# A segment will be deleted whenever *either* of these criteria are met. Deletion always happens
# from the end of the log.

# The minimum age of a log file to be eligible for deletion due to age
log.retention.hours=168

# A size-based retention policy for logs. Segments are pruned from the log unless the remaining
# segments drop below log.retention.bytes. Functions independently of log.retention.hours.
#log.retention.bytes=1073741824

# The maximum size of a log segment file. When this size is reached a new log segment will be created.
log.segment.bytes=1073741824

# The interval at which log segments are checked to see if they can be deleted according
# to the retention policies
log.retention.check.interval.ms=300000

############################# Zookeeper #############################

# Zookeeper connection string (see zookeeper docs for details).
# This is a comma separated host:port pairs, each corresponding to a zk
# server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
# You can also append an optional chroot string to the urls to specify the
# root directory for all kafka znodes.
# 配置三台zookeeper地址
zookeeper.connect=192.168.92.128:2181,192.168.92.129:2181,192.168.92.130:2181

# Timeout in ms for connecting to zookeeper
zookeeper.connection.timeout.ms=18000


############################# Group Coordinator Settings #############################

# The following configuration specifies the time, in milliseconds, that the GroupCoordinator will delay the initial consumer rebalance.
# The rebalance will be further delayed by the value of group.initial.rebalance.delay.ms as new members join the group, up to a maximum of max.poll.interval.ms.
# The default value for this is 3 seconds.
# We override this to 0 here as it makes for a better out-of-the-box experience for development and testing.
# However, in production environments the default value of 3 seconds is more suitable as this will help to avoid unnecessary, and potentially expensive, rebalances during application startup.
group.initial.rebalance.delay.ms=0
```



## 可视化工具

zookeeper

```http
https://github.com/vran-dev/PrettyZoo/releases
```

kafka

kafkaTool

## 防火墙

解决虚拟机之间连接不上的问题

```shell
# 查看防火墙状态
firewall-cmd --state
# 停止firewall
systemctl stop firewalld.service
# 禁止firewall开机启动
systemctl disable firewalld.service 
```

## 基本命令

### 查看kafka topic列表

![image-20220329181004028](kafka搭建集群.assets\image-20220329181004028.png)

```shell
./bin/kafka-topics.sh --zookeeper 127.0.0.1:2181 --list
```

### 创建topic

![image-20220329180911082](kafka搭建集群.assets\image-20220329180911082.png)

```shell
./bin/kafka-topics.sh --create --topic myTopicOne --bootstrap-server 192.168.92.128:9092
```

### 查看topic

![image-20220329181203020](kafka搭建集群.assets\image-20220329181203020.png)

```shell
./bin/kafka-topics.sh --describe --topic consoleTopic --bootstrap-server 192.168.92.128:9092
```

### 向topic中发送消息（生产消息）

![image-20220329181456177](kafka搭建集群.assets\image-20220329181456177.png)

```shell
./bin/kafka-console-producer.sh --topic myTopicOne --bootstrap-server 192.168.92.128:9092
```

### 从topic中获取消息（消费消息）

![image-20220329181553341](kafka搭建集群.assets\image-20220329181553341.png)

```shell
./bin/kafka-console-consumer.sh --topic myTopicOne --from-beginning --bootstrap-server 192.168.92.129:9092
```

















