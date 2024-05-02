elk使用的时5.6.4版本

遇到的问题
1.启动elasticsearch,不以root身份运行

```
./elasticsearch 
```

开放端口9200后不可访问?

修改配置文件中的network.host = 0.0.0.0

尽量让elk组件的版本一致,elasticsearch需要java依赖

logstash 报错

```
Java HotSpot(TM) 64-Bit Server VM warning: INFO: os::commit_memory(0x00000000c5330000, 986513408, 0) failed; error='Cannot allocate memory' (errno=12)
```

修改配置文件

conf --> jvm.options 

```
-Xms1g
-Xmx1g
# 该为以下
-Xms512m
-Xmx512m
```



elasticsearch不能使用root用户登录,其他组件如果遇到应该使用一下方法都可以



logstash 配置文件

```
input {
    file {
        path => "/var/log/nginx/access.log"
        codec => "json"
    }
}
filter {
    mutate {
        split => [ "upstreamtime", "," ]
    }
    mutate {
        convert => [ "upstreamtime", "float" ]
    }
}
output {
  stdout { codec => rubydebug }
  elasticsearch {
        hosts => ["39.107.142.3:9200"]
        index => "logstash-%{type}-%{+YYYY.MM.dd}"
        document_type => "%{type}"
        flush_size => 20000
        idle_flush_time => 10
        sniffing => true
        template_overwrite => true
    }
}
```



nginx log_format配置

```json
log_format json '{"@timestamp":"$time_iso8601",'
'"host":"$server_addr",'
'"clientip":"$remote_addr",'
'"size":$body_bytes_sent,'
'"responsetime":$request_time,'
'"upstreamtime":"$upstream_response_time",'
'"upstreamhost":"$upstream_addr",'
'"http_host":"$host",'
'"url":"$uri",'
'"xff":"$http_x_forwarded_for",'
'"referer":"$http_referer",'
'"agent":"$http_user_agent",'
'"status":"$status"}';
```

kibana中的索引时根据logstash配置文件中的output下elasticsearch的index的名字决定的



博客

```
https://developer.ibm.com/zh/technologies/analytics/articles/os-cn-elk/
```



搭建ELK

为了兼容性使用的版本全部是5.6.4,注意elasticsearch还需要jdk,至少需要1.8

下载地址

Elasticsearch: https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.4.tar.gz
Kibana: https://artifacts.elastic.co/downloads/kibana/kibana-5.6.4-linux-x86_64.tar.gz
Logstash: https://artifacts.elastic.co/downloads/logstash/logstash-5.6.4.tar.gz

默认端口
ElasticSearch: 9200
Kibana: 5601
Logstash: 5043