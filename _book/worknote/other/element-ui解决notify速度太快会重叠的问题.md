element-ui解决notify速度太快会重叠的问题

```vue
data(){
	return{
		notifyPromise: Promise.resolve(),
	}
},
methods:{
	zz(){
		this.notifyPromise = this.notifyPromise.then(this.$nextTick).then(() => {
            this.$notify.error({
              title: '题目：' + this.tableSelectionQuestionList[i].questionId + ' 添加试题篮失败!' ,
              message: '',
              duration: 3000
            })
          })
	}
}
```

