jpa

在in的时候分页

```java
@Override
    public Page<StudyTask> findPageByIdInAndSubjectCode(List<String> taskIdList, Integer subjectCode, int pageNum, int pageSize) {
        return studyTaskDao.findAll((Specification<StudyTask>) (root, query, criteriaBuilder) -> {
            List<Predicate> predicateList = new ArrayList<>();
            Expression<String> exp = root.<String>get("id");
            predicateList.add(exp.in(taskIdList));
            predicateList.add(criteriaBuilder.equal(root.get("taskType"), StudyTaskEnum.CLASS_CLEAN.getCode()));
            predicateList.add(criteriaBuilder.equal(root.get("subjectCode"), String.valueOf(subjectCode)));
            return criteriaBuilder.and(predicateList.toArray(new Predicate[0]));
        }, PageRequest.of(pageNum - 1, pageSize, Sort.by("createTime").descending()));
    }
```

待测试Specification

in的时候传入的集合不能为空,需要判断一下

jpa默认映射的时候是按照以下方式映射

```
java: userId mysql: user_id
但是如果是这样
java: userId mysql: userId
以上会报错,user_id列找不到
```

解决方案,修改配置,改变映射方案

```YML
spring:
  jpa:
    database: mysql
    show-sql: false
    open-in-view: false
    hibernate:
      naming:
        physical-strategy: org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
```



问题

rg.hibernate.LazyInitializationException: failed to lazily initialize a collection of role: xyz.taoqz.entity.Teacher.students, could not initialize proxy - no Session

解决方案

在配置文件中添加配置

```
spring.jpa.properties.hibernate.enable_lazy_load_no_trans=true
```

问题

org.hibernate.MappingException: Could not determine type for: java.util.List, at table: teacher, for columns: [org.hibernate.mapping.Column(students)]

解决方案

改变bean类映射，要不都在getter方法上写映射关系，要不就在变量上写映射关系



JPA多对多关系

@JoinTable name:关联关系表，joinColumns name:当前类映射的表Id在关联表中的字段名 ，inverseJoinColumns name: 对应的该属性在关联表的Id

```java
@ManyToMany
@JoinTable(name = "teacher_student", joinColumns = {@JoinColumn(name = "teacherId")}, inverseJoinColumns = {@JoinColumn(name = "studentId")})
public List<Student> getStudents() {
    return students;
}
```



JPA使用动态查询

JPA想使用动态查询必须在DAO接口继承多加一个JpaSpecificationExecutor<Teacher>

```java
public interface TeacherDao  extends JpaRepository<Teacher, Integer> , JpaSpecificationExecutor<Teacher> {
```

```java
private Specification<Teacher> createSpecification(Teacher teacher,List<Integer> ids) {
    return (Specification<Teacher>) (root, criteriaQuery, criteriaBuilder) -> {
        List<Predicate> predicateList = new ArrayList<>();
        predicateList.add(root.get("id").in(ids));
        if (null != teacher){
            if (StrUtil.isNotBlank(teacher.getName())) {
                predicateList.add(criteriaBuilder.like(root.get("name").as(String.class), teacher.getName()));
            }
        }
        return criteriaBuilder.and(predicateList.toArray(new Predicate[0]));
    };
}
```

jpa in操作

```
  private Specification<NotifyEntity> createSpecification(NotifyEntity notifyEntity) {

        return (Specification<NotifyEntity>) (root, criteriaQuery, criteriaBuilder) -> {
            List<Predicate> predicateList = new ArrayList<>();
            if (notifyEntity.getTeacherId() != null) {
                predicateList.add(criteriaBuilder.equal(root.get("teacherId"), notifyEntity.getTeacherId()));
            }
            if (StrUtil.isNotEmpty(notifyEntity.getTitle())) {
                predicateList.add(criteriaBuilder.equal(root.get("title").as(String.class), notifyEntity.getTitle()));
            }
            if (StrUtil.isNotEmpty(notifyEntity.getContent())) {
                predicateList.add(criteriaBuilder.equal(root.get("account").as(String.class), notifyEntity.getContent()));
            }
            if (notifyEntity.getBeginTime() != null && notifyEntity.getEndTime() != null) {
                predicateList.add(criteriaBuilder.between(root.get("publishTime").as(Timestamp.class), notifyEntity.getBeginTime(), notifyEntity.getEndTime()));
            }
            if (CollUtil.isNotEmpty(notifyEntity.getTeacherIdList())) {
                CriteriaBuilder.In<Integer> in = criteriaBuilder.in(root.get("teacherId"));
                for (Integer teacherId : notifyEntity.getTeacherIdList()) {
                    in.value(teacherId);
                }
                predicateList.add(in);
            }
            predicateList.add(criteriaBuilder.equal(root.get("flag"), 0));
            return criteriaBuilder.and(predicateList.toArray(new Predicate[0]));
        };
    }
```

