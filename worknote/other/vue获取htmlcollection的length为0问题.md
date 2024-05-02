```
this.$nextTick(function () {
  let imgDom = document.getElementsByClassName('ql-image')
  console.log(imgDom)
  console.log(imgDom.length)
  for (let i = 0; i < imgDom.length; i++) {
    imgDom[i].setAttribute('title', '上传图片')
  }
})
```

参考博客

https://blog.csdn.net/weixin_41602509/article/details/86661758