```js
 <el-table-column
                  prop="address"
                  label="操作"
                  show-overflow-tooltip>
                <template slot-scope="scope">
                  <el-button type="primary" @click="downloadResource(scope.row)">下载</el-button>
                  <el-button type="info" @click="openUpdateResource(scope.row)">修改</el-button>
                  <el-button type="danger"  @click="removeResource(scope.row.id)">删除</el-button>
                </template>
              </el-table-column>

downloadResource(row) {
    if (!this.serverUrl) {
        this.getMinioConfig()
    }
    var request = new XMLHttpRequest();
    request.responseType = "blob";
    request.open("GET", this.serverUrl + row.filePath);
    request.onload = function () {
        var url = window.URL.createObjectURL(this.response);
        var a = document.createElement("a");
        document.body.appendChild(a);
        a.href = url;
        a.download = row.fileName
        a.click();
    }
    request.send();
},
```

