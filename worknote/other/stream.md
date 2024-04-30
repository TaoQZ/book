map和flatMap的区别

```java
List<Integer> a = new ArrayList<>();
a.add(1);
a.add(2);
List<Integer> b = new ArrayList<>();
b.add(3);
b.add(4);
// 分隔字符串时会比较常用,因为split方法会把字符串分割成多个数组,利用Stream.of()方法可以获得各数组对应的流,flatMap将这多个流合并成一个流
List<Integer> figures = Stream.of(a, b).flatMap(u -> u.stream()).collect(Collectors.toList());
System.out.println(figures); // [1, 2, 3, 4]

// 返回的是流对象
List<Stream<Integer>> collect1 = Stream.of(a, b).map(u -> u.stream()).collect(Collectors.toList());
for (Stream<Integer> integerStream : collect1) {
    integerStream.forEach(System.out::println);
}
Stream.of(a, b).map(u -> u.stream()).forEach(ele -> ele.forEach(System.out::println));
```

flatMap可以将多个流合并为一个流,而map不可以合并,拿到的每一个元素还是一个流



**groupingBy/partitioningBy**分组

groupingBy

在collect中的操作Collectors.groupingBy可以按照指定属性分组,返回一个map集合,key的类型是分组属性的类型,value的类型是分组属性的类型的集合

```java
List<Person> persons = new ArrayList();
Person person1 = new Person(1, "name" + 1);
Person person2 = new Person(2, "name" + 2);
Person person3 = new Person(2, "name" + 2);
persons.add(person1);
persons.add(person2);
persons.add(person3);
Map<Integer, List<Person>> collect = persons.stream().collect(Collectors.groupingBy(Person::getId));
for (Integer integer : collect.keySet()) {
    System.out.println(integer+"  "+collect.get(integer));
}
```

partitioningBy

按照条件进行分组,返回一个Map<Boolean, List<拿流的类型>>,符合Collectors.partitioningBy(条件)的元素则为true,否则为false

```java
List<Person> persons = new ArrayList();
for (int i = 1; i <= 5; i++) {
    Person person = new Person(i, "name" + i);
    persons.add(person);
}
Map<Boolean, List<Person>> collect = persons.stream().collect(Collectors.partitioningBy(ele -> ele.getId() > 3));
System.out.println(collect.get(true)); // [Person(id=4, name=name4), Person(id=5, name=name5)]
System.out.println(collect.get(false));// [Person(id=1, name=name1), Person(id=2, name=name2), Person(id=3, name=name3)]
System.out.println(collect.size());
```

根据对象的属性去重

```java
List<CloudResource> cloudResources = new ArrayList<>();
CloudResource cloudResource1 = new CloudResource();
cloudResource1.setMd5("1");
cloudResource1.setRefFilePath("1");

CloudResource cloudResource2 = new CloudResource();
cloudResource2.setMd5("2");
cloudResource2.setRefFilePath("2");

System.out.println(cloudResource1);
System.out.println(cloudResource2);

cloudResources.add(cloudResource1);
cloudResources.add(cloudResource2);

//        cloudResources = cloudResources.stream().filter(ele -> fileUploadUtilByMinio.statObject(ele.getRefFilePath())).collect(Collectors.collectingAndThen(Collectors.toCollection(() ->
cloudResources = cloudResources.stream().filter(ele -> Integer.parseInt(ele.getMd5()) >= 1).collect(Collectors.collectingAndThen(Collectors.toCollection(() ->
//                new TreeSet<>(Comparator.comparing(CloudResource::getMd5))), ArrayList::new));
                new TreeSet<>(Comparator.comparing(ele -> ele.getMd5()+ele.getRefFilePath()) )), ArrayList::new));

cloudResources.forEach(ele -> System.out.println(ele.getRefFilePath()+"=="+ele.getMd5()));
```



将一对象集合根据属性转变为一个map集合,如果作为key得对象得属性有重复得可以选择使用第一个还是第二个

```java
ArrayList<User> usersA = new ArrayList<>();
ArrayList<User> usersB = new ArrayList<>();

Collections.addAll(usersA,
                   new User("张三",10.0),
                   new User("李四",20.0),
                   new User("王五",30.0)
                  );

Collections.addAll(usersB,
                   new User("李四",40.0),
                   new User("赵六",50.0),
                   new User("张三",60.0)
                  );

ArrayList<User> result = new ArrayList<>();
result.addAll(usersA);
result.addAll(usersB);
System.out.println(result);

Map<String, Double> collect = result.stream().collect(Collectors.toMap(User::getName, User::getSalary, (e1, e2) -> e2));
for (String s : collect.keySet()) {
    System.out.println(s+"  "+collect.get(s));
}
```

```java
// 效果
[User(name=张三, salary=10.0), User(name=李四, salary=20.0), User(name=王五, salary=30.0), User(name=李四, salary=40.0), User(name=赵六, salary=50.0), User(name=张三, salary=60.0)]
李四  40.0
张三  60.0
王五  30.0
赵六  50.0
```

