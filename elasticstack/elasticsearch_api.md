# Elasticsearch api



## reindex

### 远程集群reindex

远程集群需在 elasticsearch.yml 中配置

```
reindex.remote.whitelist: "192.168.10.19:9200"
```

```json
POST 192.168.10.63:9200/_reindex

{
  "source": {
    "remote": {
      "host": "http://192.168.10.63:9200"
    },
    "index": "zc_machine",
    "size": 10000
  },
  "dest": {
    "index": "tao_dest_src"
  },
  "size": 100
}
```

### 本集群reindex

```json
POST 192.168.10.65:9200/_reindex

{
  "source": {
    "index": "zc_machine",
    "size": 10000
  },
  "dest": {
    "index": "tao_dest_src"
  }
}
```

### 查看进度

```http
GET 192.168.10.65:9200/_tasks?detailed=true&actions=*reindex
```

### 取消reindex

```http
POST 192.168.10.63:9200/_tasks/FNotLQhjTP-0RvQNCV7jWQ:20558642/_cancel
```



## 基本操作

### 创建索引-并设置mappings、settings和aliases

```json
PUT 192.168.10.65:9200/tao_dest_src

{
    "aliases":{

    },
    "mappings":{
        "properties":{
            "appPerson":{
                "type":"text",
                "fields":{
                    "keyword":{
                        "type":"keyword",
                        "ignore_above":256
                    }
                }
            }
        }
    },
    "settings":{
        "index":{
            "refresh_interval":"1s",
            "number_of_shards":"1",
            "translog":{
                "sync_interval":"60s",
                "durability":"async"
            },
            "max_result_window":"50000",
            "number_of_replicas":"1"
        }
    }
}
```

### 查询

```json
POST http://192.168.123.252:9200/zc_network_connection/_search

{
    "query":{
        "match":{
            "_id":"0032043cccc8473da03656f482d4bc9e"
        }
    },
    "from": 0,
    "size": 10
}
```

### 插入

```json
POST http://192.168.123.159:9200/zc_user/_doc

{
    "userExpireTime":"never",
    "syncTime":1649185386309,
    "userStatus":1,
    "softwareVersion":"win_3.1.23.17",
    "machineIp":"192.168.123.14"
}
```

### 删除

```json
POST http://192.168.10.63:9200/tao_dest_event/_delete_by_query

{
  "query": { 
    "match_all": {
     
    }
  }
}
```

### 添加mapping

```json
PUT http://192.168.10.201:9200/zc_process/_mapping

{
  "properties":{
    "installationTime":{
      "type":"long",
      "index":false
    }
  }
}
```

### 向索引增加mapping

```json
PUT http://192.168.123.159:9200/zc_web/_doc/_mapping?include_type_name=true

{
    "properties":{
        "machinePrimaryIps":{
          "type": "nested",
          "properties":{
            "ip":{
                "type":"text",
                "fields":{
                    "keyword":{
                        "type":"keyword",
                        "ignore_above":256
                    }
                }
            },
            "ipLong":{
                "type":"long"
            },
            "source":{
                "type":"long"
            },
            "type":{
                "type":"long"
            },
            "version":{
                "type":"long"
            }
          }
            
        }
    }
}

```

### 查看mapping

```http
GET http://192.168.123.252:9200/zc_process/_mapping
```

### 查看索引的设置

```http
GET http://192.168.123.159:9200/zc_machine/_settings
```

### 根据ID查询

```http
GET http://192.168.123.159:9200/zc_database/_doc/o8EznIABWwFXVZOQ4Wuu
```

### 根据ID增量更新

```json
POST 192.168.10.65:9200/tao_dest_src/_doc/6f98e312e4d3392e873324ff1aa36d63/_update?refresh=true

{
    "doc":{
            "onlineStatus": 1
    }
}
```

### 添加别名

```json
POST 192.168.10.63:9200/_aliases

{
    "actions":[
        {
            "add":{
                "index":"tao_dest_event",
                "alias":"zzz"
            }
        }
    ]
}
```



## having

```json
POST _sql?format=json
{
  "query" : "select machineIp,count(1) c from zc_machine group by machineIp having c >= 5 "
}
```

```json
{
  "columns" : [
    {
      "name" : "machineIp",
      "type" : "text"
    },
    {
      "name" : "c",
      "type" : "long"
    }
  ],
  "rows" : [
    [
      "192.168.10.56",
      5
    ]
  ],
  "cursor" : "49itAwFaAWMBCnpjX21hY2hpbmWUAgEBCWNvbXBvc2l0ZQdncm91cGJ5AAEPYnVja2V0X3NlbGVjdG9yC2hhdmluZy4yNDM0AQZfY291bnT/AQJhMAZfY291bnQAAQhwYWlubGVzc1ZJbnRlcm5hbFNxbFNjcmlwdFV0aWxzLm51bGxTYWZlRmlsdGVyKEludGVybmFsU3FsU2NyaXB0VXRpbHMuZ3RlKHBhcmFtcy5hMCxwYXJhbXMudjApKQoACgECdjABAAAABQH/AQAEMjQ4MwERbWFjaGluZUlwLmtleXdvcmQAAAEAAOgHAQoBBDI0ODMADTE5Mi4xNjguMTAuNzMAAgEAAAAAAQD/////DwAAAAAAAAAAAAAAAAFaAwACAgAAAAAAAP////8PAgFrBDI0ODMAAAFrBDI0ODMBAAEDAA=="
}

```

```json
POST _sql/translate
{
  "query" : "select machineIp,count(1) c from zc_machine group by machineIp having c >= 5 "
}
```

```java
SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();

TermsAggregationBuilder field = AggregationBuilders.terms("machineUuidTerms").field("machineIp.keyword");

Script script = new Script("params.count >= 3");
Map<String, String> bucketsPathsMap = new HashMap<>();
bucketsPathsMap.put("count", "_count");

BucketSelectorPipelineAggregationBuilder having = PipelineAggregatorBuilders.bucketSelector("having", bucketsPathsMap, script);
field.subAggregation(having);


searchSourceBuilder.aggregation(field);
BoolQueryBuilder boolQueryBuilders = QueryBuilders.boolQuery();

searchSourceBuilder.query(boolQueryBuilders);
Search search = new Search.Builder(searchSourceBuilder.toString()).addIndex("zc_machine").build();
SearchResult searchResult = null;
searchResult = jestClient.execute(search);
System.out.println();
```

```json
{
    "query":{
        "bool":{
            "adjust_pure_negative":true,
            "boost":1
        }
    },
    "aggregations":{
        "machineUuidTerms":{
            "terms":{
                "field":"machineIp.keyword",
                "size":10,
                "min_doc_count":1,
                "shard_min_doc_count":0,
                "show_term_doc_count_error":false,
                "order":[
                    {
                        "_count":"desc"
                    },
                    {
                        "_key":"asc"
                    }
                ]
            },
            "aggregations":{
                "having":{
                    "bucket_selector":{
                        "buckets_path":{
                            "count":"_count"
                        },
                        "script":{
                            "source":"params.count >= 3",
                            "lang":"painless"
                        },
                        "gap_policy":"skip"
                    }
                }
            }
        }
    }
}
```

