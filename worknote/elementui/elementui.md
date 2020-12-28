keydown事件

```html
<el-form :model="admin" :rules="rules" ref="ruleForm" label-width="100px"
         class="demo-ruleForm"
         @keyup.enter.native="submitForm('ruleForm')">
```

下载文件

```html
<el-table-column
  prop="fileName"
  label="资源名"
  min-width="200">
  <template slot-scope="scope">
    <div v-if="scope.row.dataType == 'resource'">
      <el-link :href="scope.row.refFilePath +'?attname='+ scope.row.fileName "
               type="primary" target="_blank">{{ scope.row.fileName }}
      </el-link>
   
    </div>
    <div v-else>
      <el-button type="text" @click="showDetailNew(scope.row)">{{ scope.row.name }}
      </el-button>
    </div>
  </template>
</el-table-column>
```

vue+elementui+springboot 多文件上传

```
<el-upload
                class="upload-demo"
                ref="upload"
                action=""
                :on-remove="handleRemove"
                :on-change="handleChange"
                :file-list="fileList"
                :auto-upload="false">
              <el-button slot="trigger" icon="el-icon-folder-add" size="small" type="primary">选取文件</el-button>
              <div slot="tip" class="el-upload__tip">支持图片、音频、视频、文档，且视频最大100M，文档最大15M</div>
            </el-upload>
```

```
handleRemove(file, fileList) {
      this.fileList = fileList
    },
    handleChange(file, fileList) {
      this.fileList = fileList
    },
    
    fileList: [],

```

```
 addResource() {
      let formData = new FormData()
      for (let i = 0; i < this.fileList.length; i++) {
        formData.append('files', this.fileList[i].raw)
      }
      formData.append('refCatalogId', this.catalogId)
      this.axios.post('/resourceManage/upload', formData)
          .then(res => {
            this.$message({
              message: res.data.message,
              type: 'warning'
            });
            console.log(res.data.message)
            this.findResourceByRefCatalogId()
          })
      this.fileList = []
      // upload 是文件上传组件的ref
      this.$refs.upload.clearFiles()
    },
```

```
   @PostMapping("/upload")
    public Result uploadResource(@RequestParam MultipartFile[] files, ResourceManage resourceManage) {
        if (ArrayUtil.isEmpty(files)) {
            return Result.fail("未上传文件");
        }
        StringBuilder result = new StringBuilder();
        for (MultipartFile file : files) {
            result.append(resourceManageService.uploadResource(file, resourceManage.getRefCatalogId()));
        }
        if (StrUtil.isNotBlank(result.toString())) {
            return Result.ok(result.toString());
        }
        return Result.ok("上传成功");
    }
```

