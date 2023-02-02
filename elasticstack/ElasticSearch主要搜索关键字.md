ElasticSearch主要搜索关键字



## **前提条件**

首先存入一条数据 i like eating and kuing 默认分词器应该将内容分为 “i” “like” “eating” “and” “kuing”

注意如果使用supplierName.keyword做查询（数据源采用es库中不分词数据）

SearchSourceBuilder对应着查询json结构的最外层（from，size，query，filter，sort，aggs）

QueryBuilder 对应着各种过滤条件：精确搜索，布尔，范围



## **1 QueryBuilders.matchQuery(“supplierName”,param)**

match查询，会将搜索词分词，再与目标查询字段进行匹配，若分词中的任意一个词与目标字段匹配上，则可查询到。



输入条件

| param                   | 结果   |
| ----------------------- | ------ |
| i                       | 可查出 |
| i li                    | 可查出 |
| i like                  | 可查出 |
| i like eat              | 可查出 |
| and                     | 可查出 |
| kuing                   | 可查出 |
| ku                      | 查不出 |
| li                      | 查不出 |
| eat                     | 查不出 |
| i like eating and kuing | 可查出 |



分词后精确查询，分词之间or关系,有一个分词匹配即匹配

如果使用  "match": {"message.keyword": "xxx"}，即不分词只有 i like eating and kuing可以查出



## **2 QueryBuilders.matchPhraseQuery(“supplierName”,param)**

默认使用 match_phrase 时会精确匹配查询的短语，需要全部单词和顺序要完全一样，标点符号除外。



| param                   | 结果   |
| ----------------------- | ------ |
| i                       | 可查出 |
| i li                    | 查不出 |
| i like                  | 可查出 |
| i like eat              | 查不出 |
| and                     | 可查出 |
| kuing                   | 可查出 |
| ku                      | 查不出 |
| li                      | 查不出 |
| eat                     | 查不出 |
| i like eating and kuing | 可查出 |



有序连贯分词模糊查询（任意分词任意数量按照原有顺序连续排列组合可以查出，其他不可查出）

如果使用  "match_phrase": {"message.keyword": "xxx"}，即不分词只有 i like eating and kuing可以查出



## **3 QueryBuilders.matchPhrasePrefixQuery(“supplierName”,param)**

match_phrase_prefix 和 match_phrase 用法是一样的，区别就在于它允许对最后一个词条前缀匹配。

与match_phrase唯一区别  param = “i like eating and kui” 查出



最后一个词条之前的词匹配规则与match_phrase相同++最后一个此条为前缀进行模糊匹配

match_phrase_prefix不能使用supplierName.keyword模式



## **4 QueryBuilders.termQuery(“supplierName”,param)**

term query,输入的查询内容是什么，就会按照什么去查询，并不会解析查询内容，对它分词。

| param                   | 结果   |
| ----------------------- | ------ |
| i                       | 可查出 |
| i li                    | 查不出 |
| i like                  | 查不出 |
| i like eat              | 查不出 |
| and                     | 可查出 |
| kuing                   | 可查出 |
| ku                      | 查不出 |
| li                      | 查不出 |
| eat                     | 查不出 |
| i like eating and kuing | 查不出 |





查询条件不分词精确匹配分词数据，命中一个分词即匹配

param = “i like eating and kuing” 查不出

如果使用  "term": {"message.keyword": "xxx"}，即不分词只有 i like eating and kuing可以查出



## **5 QueryBuilders.wildcardQuery(“supplierName”,"\*"+param+"\*")** 

条件wildcard不分词查询，加*（相当于sql中的%）表示模糊查询，加keyword表示查不分词数据

{"wildcard":{"message.keyword":"*atin*"} 等同sql于like查询

不能使用supplierName.keyword模式



## **总结**

fieldName.keyword决定是否采用es分词数据源，不带keyword即查询text格式数据（分词），带即查询keyword格式数据（不分词）

见https://blog.csdn.net/tyw15/article/details/111935033

match，match_phrase，match_phrase_prefix，term，wildcard决定查询条件分词形式以及分词后的查询条件关联关系

1、2、4使用.keyword查询相当于不分词精确匹配，5是模糊查询，其他都是变种分词组合模糊查询



BoolQueryBuilder queryBuilder= QueryBuilders.boolQuery();



\* must:  AND

\* mustNot: NOT

\* should:: OR



queryBuilder.must(QueryBuilders.termQuery("user", "kimchy"))

​      .mustNot(QueryBuilders.termQuery("message", "nihao"))

​      .should(QueryBuilders.termQuery("gender", "male"));