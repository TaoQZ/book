

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