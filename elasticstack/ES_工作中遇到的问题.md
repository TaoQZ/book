

# 工作中遇到的问题

## 1、数据添加到索引后延迟显示问题

当数据添加到索引后并不能马上被查询到，等到索引刷新后才会被查询到。 **refresh_interval** 配置的刷新间隔。如果我们有需求必须要进行实时更新可以添加参数 **refresh(true)**

```java
UpdateByQuery updateByQuery = new UpdateByQuery.Builder(source).addIndex(getIndexName(userUuid)).addType("doc").refresh(true).build();
```



## 2、时间聚合，类型问题

有一些查询会使用到比如 24小时内或者一周或者一个月的 数据，在使用对应的API时需要注意

```java
 DateHistogramAggregationBuilder dateHistogramAggregationBuilder = AggregationBuilders.dateHistogram("dayAgg")
                .field("standardTimestamp")
                .fixedInterval(DateHistogramInterval.DAY)
                .order(BucketOrder.key(false))
                .minDocCount(0L)
                .timeZone(zoneId)
                .format(DateUtil.YYYY_MM_DD_HH_MM_SS)
                .extendedBounds(new ExtendedBounds(now.toInstant(ZoneOffset.ofHours(8)).toEpochMilli(), plus.toInstant(ZoneOffset.ofHours(8)).toEpochMilli()));
```

该示例使用的字段是 standardTimestamp 一开始使用的是long类型，得出的结果会从前一天的8点开始，总之数据是错误的，需要将该字段改为 date 类型

又因为索引建立后不允许修改mapping,所以在入库时还需要注意这个问题



## 3、nested字段 + 普通类型字段 聚合

```java
// 使用nested字段 + 普通类型字段聚合 
// 如果还是直接去追加 subAggregation 那么会自动把这个字段也当作是第一个的nested path（userDatas）下的字段，但machineUuid并不是，所以需要先从nested字段中跳出来 
// 使用 AggregationBuilders.reverseNested API 可以做到 
NestedAggregationBuilder nested = AggregationBuilders.nested("userDatas", "userDatas"); 
TermsAggregationBuilder machineTags = AggregationBuilders.terms("machineTags").field("userDatas.machineTags.keyword").size(Integer.MAX_VALUE); 
TermsAggregationBuilder userDataUuid = AggregationBuilders.terms("userUuid").field("userDatas.userUuid.keyword").size(Integer.MAX_VALUE);

userDataUuid.subAggregation(machineTags); 
nested.subAggregation(userDataUuid); 

CardinalityAggregationBuilder machineCount = AggregationBuilders.cardinality("machineCount").field("machineUuid.keyword"); 
ReverseNestedAggregationBuilder revers = AggregationBuilders.reverseNested("revers").subAggregation(machineCount); 
machineTags.subAggregation(revers); 
searchSourceBuilder.aggregation(nested);
```

## 4、es having操作

```java
// 这里的count对应的 bucketsPathsMap 中的key count
Script script = new Script("params.count == 0");
Map<String, String> bucketsPathsMap = new HashMap<>();
// 这里的malicious对应的 AggregationBuilders.cardinality("malicious") 里的名称
bucketsPathsMap.put("count", "malicious.value");
BucketSelectorPipelineAggregationBuilder having = PipelineAggregatorBuilders.bucketSelector("having", bucketsPathsMap, script);
CardinalityAggregationBuilder malicious = AggregationBuilders.cardinality("malicious").field("maliciousList.keyword");
TermsAggregationBuilder machineTerm = AggregationBuilders.terms("machineTerm").field("outreachMachine.keyword").size(Integer.MAX_VALUE);
machineTerm.subAggregation(malicious);
machineTerm.subAggregation(having);

searchSourceBuilder.query(boolQueryBuilder);
searchSourceBuilder.aggregation(machineTerm);
```

## 5、查询数组为空的数据
exists query

Returns documents that contain an indexed value for a field.

An indexed value may not exist for a document’s field due to a variety of reasons:

The field in the source JSON is null or []
The field has “index” : false set in the mapping
The length of the field value exceeded an ignore_above setting in the mapping
The field value was malformed and ignore_malformed was defined in the mapping

```json
GET zc_machine/_search
{

  "query": {
    "bool": {
      "must": [
        {
          "exists": {
            "field": "orgDatas"
          }
        }
      ]
    }
  },
  "aggs": {
    "ms": {
      "terms": {
        "field": "machineUuid.keyword",
        "size": 1000
      }
    }
  }
}
```



## 6、查询数组中同时包含两个及以上的值

```json
PUT tao_ce
{
  "mappings" : {
    "properties" : {
      
    }
  }
}

POST _bulk
{ "index" : { "_index" : "tao_ce", "_id" : "1" } }
{ "name": "hh", "hobbis":["游泳", "篮球","足球"]}
{ "index" : { "_index" : "tao_ce", "_id" : "2" } }
{ "name": "xx", "hobbis":["乒乓球", "篮球","足球"]}
{ "index" : { "_index" : "tao_ce", "_id" : "3" } }
{ "name":"zz", "hobbis":["乒乓球", "篮球","网球"]}


GET tao_ce/_search
{
  "query": {
    "match_all": {
      
    }
  }
}

### 可以，使用 must-term array
GET tao_ce/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "hobbis.keyword": {
              "value": "游泳"
            }
          }
        },
        {
          "term": {
            "hobbis.keyword": {
              "value": "足球"
            }
          }
        }
      ]
    }
  }
}

### 不可以，文档中包含查询条件数组其一即返回
GET tao_ce/_search
{
  "query": {
    "bool": {
      "must": [
        {
         "terms": {
           "hobbis.keyword": [
             "游泳",
             "足球"
           ]
         }
        }
      ]
    }
  }
}

```

















