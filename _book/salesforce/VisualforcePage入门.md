# VisualforcePage入门

-  Visualforce是一个和Apex语言相匹配的开发框架。开发者可以使用Visualforce和Apex建立自定义网络应用程序。 
-  Visualforce的基本功能类似于前端框架，可以构建页面，与后端的Apex进行数据交流，并将结果显示给用户。在MVC结构中扮演V的角色。 
-  Visualforce还可以与Salesforce系统中的标准功能相结合，对标准功能进行扩展或重写。 



## 常用标签

### 输入标签

- 常用标签

```html
apex:pageBlock  列表展示标签 父标签，包含以下标签
apex:pageBlockSection	相当于div内部展示标签，column 可以展示这一块 水平展示几个
apex：pageBlockTable    展示列表

<apex：inputCheckbox >   复选框
<apex：inputField >		下拉列表的输入框，跟根据属性的数据类型，来展示不同的形式
<apex：inputSecret >		
<apex：inputText >		输入标签
<apex：inputTextarea >	长文本
<apex：outputField >		展示字段d
<apex：outputText >		展示文本信息
<apex：selectCheckboxes >	多个复选框
<apex：selectList >		展示数组
<apex：selectRadio >		单选框
    
<apex:outputPanel>		输出面板，输出的信息

<apex:form></apex:form> //表单标签
<apex：commandLink > 标签以提交表单。
<apex：commandButton > 标签以提交表单。
```

- 代码：

  ```xml
  <apex:page standardController="Goods__c" showHeader="false">
      
      <apex:form>
      	<apex:pageBlock title="{! $User.FirstName}">
              <apex:pageBlockSection title="内容" columns="1">
                  <apex:inputCheckbox value="{!goods__c.GoodsName__c}"/>  复选框
                  <apex:inputFile value="{!goods__c.GoodsName__c}" />  //文件上传
  
                  <apex:inputHidden value="{!goods__c.GoodsName__c}"/> //隐藏的输入框...
                  
  				<apex:inputSecret value="{!goods__c.GoodsName__c}"/>  密码输入框
                  <apex:inputText value="{!goods__c.GoodsName__c}"></apex:inputText>  普通输入
                  <apex:inputField value="{!goods__c.GoodsName__c}"/>
                  
                  ---------------------------------------------------------------------
                  <apex:outputText value="{!goods__c.GoodsName__c}" />
                  <apex:selectCheckboxes value="{!goods__c.GoodsName__c}"/>  //传入集合可以 展示多个复选框
                  <apex:selectList value="{!goods__c.GoodsName__c}" /> //下拉列表
                  <apex:selectRadio value="{!goods__c.GoodsName__c}"></apex:selectRadio>  //单选框
              </apex:pageBlockSection>
              <apex:pageBlockSection title="保存按钮" columns="1">
                  <apex:commandButton action="{!save}" value="保存"/>
                  <apex:commandLink action="{!save}" value="保存他妈的"/>
              </apex:pageBlockSection>
          </apex:pageBlock>
      </apex:form>
      
      <!-- 使用静态资源 , 指定静态的图片 -->
      <img src="{!$Resource.img1}"/>
  </apex:page>
  ```

- 页面效果：

  ![](assets\6.png)

### 标签综合

- 图片

  <img src="assets\9.png" style="zoom:200%;" />

### form表单，列表标签

- 列表标签等，都需要包含在 `<apex:form>` 标签中

  ```xml
  <apex:form>  								form表单表现
  <apex:pageBlock >							一块区域，类似于 div标签
  <apex:pageMessages />						报错展示的标签
  <apex:pageBlockButtons location="bottom">	按钮组标签，一组按钮
  <apex:commandButton value="Save" action="{!save}"/>		按钮标签
  <apex:pageBlockTable value="{!accounts}" var="a">		列表标签
  <apex:column value="{!a.name}" headerValue="名称展示"/>		列标签
  <apex:pageBlockSection title="goods" columns="1">		可隐藏的块标签
      
  <apex:commandLink value="delete" action="{!deleteGoods}"> a标签连接那妞
  <apex:param name="goodsId" value="{!goods.Id}"/>	在按钮中携带参数
  controller中获取传递的参数：
  Id id = ApexPages.currentPage().getParameters().get('goodsId');
  
  VFPage页面中获取路劲 cid参数：
  {!$CurrentPage.parameters.cid}
      
  ------------------------------------------------------------------
  <apex:inlineEditSupport event="ondblClick" />		单个编辑标签
  <!-- 开启内联编辑，event设置双击 开启编辑内容 -->
  <!-- showOnEdit双击内联编辑后 要展示的button按钮 -->
  <!-- hideButton 双击内联编辑后，隐藏的button按钮 -->
  <apex:inlineEditSupport event="ondblClick" showOnEdit="saveButton,cancelButton" hideOnEdit="editButton" /> 
  ```

### 请求标签，a标签

-  `apex:outputLink`   请求标签，类似于HTMl中 a 标签

- 设置 value 属性值，可以跳转到 外部互联网页面，并且可以携带参数

  ```xml
  //携带的 查询内容。卸载 value 请求url中
  <apex:outputLink value="http://google.com/search?q={!account.name}">
      Search Google
  </apex:outputLink>
  // 需要携带的数据，写在 apex:param 中
  <apex:outputLink value="http://google.com/search">
      Search Google
      <apex:param name="q" value="{!account.name}"/>
  </apex:outputLink>
  
  //获取请求参数
  VFPage中：{!$CurrentPage.parameters.XXX}
  
  controller中：
  Id id = ApexPages.currentPage().getParameters().get('goodsId');
  ```

### commandLink和detail

- 可以通过`<apex:commandLink>` 中设置一个 `<apex:param name="cid" value="{!contact.id}">` 的方法来 进行页面 中的效果展示

- 代码如下：

  ```xml
  <apex:page standardController="Account">
      <apex:pageBlock title="Contacts">
          <apex:form>
              <apex:dataTable value="{!account.Contacts}" var="contact" cellPadding="4" 
                                 border="1">
                <apex:column>
                   <!-- 设置一列的标头 -->
                 <apex:facet name="header">Name</apex:facet>
                  <!-- 通过commandLink进行按钮的绑定，param来传递一个参数 -->
                 <apex:commandLink>
                   {!contact.Name}
                   <apex:param name="cid" value="{!contact.id}"/>
                 </apex:commandLink> 
                    
                </apex:column>
              </apex:dataTable>
          </apex:form>
      </apex:pageBlock>
      <!-- 监听页面中的 cid参数，当commandLink点击时，传递一个cid的param参数，此组件就会展示效果 -->
      <apex:detail subject="{!$CurrentPage.parameters.cid}" relatedList="false"/>
  </apex:page>
  ```

- 效果图：

  ![](assets\11.png)





---



## 插值表达式

-  Visualforce页面可以与后端交流并得到数据。要在页面中显示这些数据，可以使用固定格式的变量和表达式。 

  ```
  {! 变量或表达式名字 }
  ```

## selectList下拉列表值获取

- 赋值展示 下拉列表

  ```xml
  <!-- 进行页数的跳转 -->
  <apex:selectList multiselect="false" size="1" label="分页跳转:" onchange="chanNum()" value="{!pageNum}">
                          
      <!-- 中间方法，通过actionFunction 来调用controller方法 -->
      <apex:actionFunction action="{!pageNum}" name="chanNum"/>
  
      <apex:selectOptions value="{!Nums}">
      </apex:selectOptions>
  </apex:selectList>
  ```

- Nums 数据 只能是 List<selectOption> 格式的：

  ```java
      //返回总页数 , 从0开始计算
      public List<selectOption> getNums(){
          List<selectOption> nums = new List<selectOption>();
          for(integer i = 0 ; i < con.getPageSize()+1 ; i++){
              nums.add(new SelectOption(i+1+'' , i+1+''));
          }
          return nums;
      }
  ```

- 当切换 下拉值 的时候调用 controller中的方法。进行页面的跳转

  ```
  //设置一个中间 函数调用方法， selectList 绑定change事件，调用 chanNum方法 就可以调用controller方法
  <!-- 中间方法，通过actionFunction 来调用controller方法 -->
  <apex:actionFunction action="{!pageNum}" name="chanNum"/>
  
  通过selectList 的value 与controller 的pageNum 进行数据绑定。 改变的数据会自动封装到 pageNum 中。
  public String pageNum {get;set;}
  ```

## 全局变量

-  Visualforce中预定义了一些全局变量。在使用这些全局变量时，要在变量名前加“$”符号。 

  ```
  <!-- 显示用户的全名，并在FirstName和LastName之间加入一个空格 -->
  {! $User.FirstName & ' ' & $User.LastName }
  
  <!-- 显示当前日期的年份 -->
  {! YEAR(TODAY()) }
  
  <!-- 如果用户状态是激活的，则显示用户名，否则显示“inactive”字样 -->
  {! IF($User.isActive, $User.Username, 'inactive') } 
  ```

- 代码案例：

  ```html
  <!-- showHeader为false不显示salesforce的标准页面：侧边栏，菜单栏等 -->
  <apex:page showHeader="false">
      <h1>
          This si title.
      </h1>
      <p>
          这是一个内容
      </p>
      
      <!-- pageBlock创建一个可隐藏的列表 -->
      <apex:pageBlock title="page book title">
          <!-- pageBlockSection创建Block下面的列表页面 -->
      	<apex:pageBlockSection title="giaogiao内容">
              
              <!-- VF中预设置了一些全局变量，通过 $XX的方式可以获取 -->
          	<!-- 显示用户的全名，并在FirstName和LastName之间加入一个空格 -->
              {! $User.FirstName & ' ' & $User.LastName }
              <br/>
              <!-- 显示当前日期 -->
              {! YEAR(TODAY()) } -- {! Month(TODAY()) } -- {! Day(TODAY()) }
  			<br/>            
              <!-- 如果用户状态是激活的，则显示用户名，否则显示“inactive”字样 -->
              {! IF($User.isActive, $User.Username, 'inactive') } 
              
          </apex:pageBlockSection>
      </apex:pageBlock>
  </apex:page>
  ```

- 效果图：

  ![](assets\2.png)

## Apex控制器

-  Visualforce框架是遵循MVC结构的。Visualforce页面代表了“视图”部分，Salesforce的各种对象代表了“模型”部分，而Apex则代表了“控制器”部分。 
-  在Visualforce页面中的“apex:page”标签里可以绑定控制器。 

### 标准控制器

- Salesforce中为标准对象预定义了标准的控制器类，不需要用户配置即可直接使用。

  比如要在Visualforce页面中绑定Account对象，可以这样写：

  ```
  <apex:page standardController="Account"> 
  ```

- 代码如下：

  ```xml
  <!-- showHeader为false不显示salesforce的标准页面：侧边栏，菜单栏等 -->
  <!-- standardController 标准Controller ， 单个对象，所以在页面载入时需要id值 -->
  <apex:page showHeader="false" standardController="Account">
      <!-- pageBlock创建一个可隐藏的列表 -->
      <apex:pageBlock title="Account 数据">
          <!-- pageBlockSection创建Block下面的列表页面 -->
      	<apex:pageBlockSection title="Account">
  			Name: {!Account.Name}
              <br/>
  			Phone: {! Account.Phone }
              <br/>
              <!-- Account.Owner当前对象 拥有者的对象，用户对象 -->
  			Owner: {! Account.Owner.FirstName & ' ' & Account.Owner.LastName }
          </apex:pageBlockSection>
      </apex:pageBlock>
  </apex:page>
  ```

- 代码解释：

  -  URL的最后还可以加入“?id=”参数来传入页面中要显示的对象的ID。 
  -  代码的“apex:page”标签中，使用了“standardController”属性，将其定义为“Account”。这就是告诉Salesforce该页面在载入时，需要在URL中接收一个Account对象的ID值，并在数据库中查询得到该对象的信息，存入“Account”变量供页面使用。 

- 页面效果：

  ![](assets\3.png)

#### 标准组件显示内容

-  Visualforce中提供了一系列标准组件，可以直接格式化输出对象的各种内容。 

- 代码改为：

  ```xml
  <apex:page standardController="Account">
      <apex:pageBlock title="Account Info">
          <apex:pageBlockSection>
              <!-- 使用标准组件，来显示信息 -->
              <apex:detail />
          </apex:pageBlockSection>
      </apex:pageBlock>
  </apex:page>
  ```

- 标准效果展示：

  ![](assets\4.png)

#### 显示多条数据

-  使用标准控制器类，不光可以绑定一个对象变量，也可以绑定一个列表变量。 
-  在“apex:page”标签中，设置“recordSetVar”属性，即可让标准控制器返回一个包含此对象数据的列表。 

```xml
<apex:page standardController="Goods__c" recordSetVar="goodses">
    <!-- 指定标准对象Account ， 使用recordSetVar来设置显示多条数据 -->
    <apex:pageBlock title="Account Info">
        
        <!-- pageBlockTable列表展示组件，value设置要循环的变量数组，var为每一个值
 headerValue ： 列表头名称-->
            <apex:pageBlockTable value="{! goodses }" var="acc" headerValue="我敲">
                <!-- column为每一行的数据展示 -->
                <apex:column value="{! acc.GoodsName__c }"/>
            </apex:pageBlockTable>
         	<apex:pageBlockTable value="{! goodses }" var="acc" title="Id鸭">
                <apex:column value="{! acc.Id }"/>
            </apex:pageBlockTable>
    </apex:pageBlock>
</apex:page>
```

- 展示效果：

  ![](assets\5.png)

#### 标准控制器扩展类

-  在标准的控制器类中，开发者可以很方便的使用系统自定义的各种功能。而控制器扩展则可以对标准控制器类的功能进行扩展。 

- 在“apex:page”标签中，在已经有“standardController”变量后，设置“extensions”变量，即可设定扩展类。 

-  一个扩展类的构造函数必须使用ApexPages.StandardController类型的参数。 

- 扩展类代码：

  ```java
  public class ExampleControllerExtension {
      
      //为VF的标准控制器 扩展类 , 携带一个ApexPages.StandardController参数
      public ExampleControllerExtension(ApexPages.StandardController stdController){
          //使用标准控制器变量的getRecord()方法可以获得相应的sObject对象的值.
          Goods__c goods = (Goods__c)stdController.getRecord();
          System.debug(goods);
      }
      
      public String getexampleCustomMessage(){
          return 'Hello World';
      }
  
  }
  ```

- VFpage中：

  ```xml
  <apex:page standardController="Goods__c" extensions="ExampleControllerExtension">
      <!-- 可以指定标准扩展类的某一个get方法，返回值显示在页面上 , 省略get，不区分大小写-->
  	{!ExampleCustomMessage}
  </apex:page>
  ```

### 自定义控制器类

-  除了标准控制器类，Visualforce页面还可以指定自定义的Apex类作为控制器类。 

-  设定“controller”属性的值为自定义的Apex类的名字。 

-  Salesforce有默认的“get函数”机制，可以从控制器类中自动得到页面中使用的变量的值。当页面中使用变量“abc”，那么“abc”的值会自动由控制器中的“getAbc()”函数来得到。此机制适用于单独对象变量和列表对象变量。 

- Apex自定义控制器代码：

  ```java
  public class GoodsController2 {
  	//VF数据交互的 Apex后端数据
      public List<Goods__c> getGoodses(){
          //返回给 VF界面一些数据
          List<Goods__c> goodses = [select Id , GoodsName__c from Goods__c];
          
          return goodses;
      }
  	
  }
  ```

- VFpage界面代码：

  ```xml
  <apex:page controller="GoodsController2">
      <!-- 可以指定标准扩展类的某一个get方法，返回值显示在页面上 , 省略get，不区分大小写-->
  	<apex:pageBlock title="所有Goods数据">
      	<apex:pageBlockTable value="{!Goodses}" var="goods">
          	<apex:column value="{!goods.Id}"/>
              <apex:column value="{!goods.GoodsName__c}"/>
          </apex:pageBlockTable>
      </apex:pageBlock>
  </apex:page>
  ```

## 使用静态资源

- 在设置面板中，搜索静态资源，可以管理 salesforce 下的静态资源。

-  可以上传各种文件，比如zip文件、jpg文件、css文件、图像文件等。 

- 使用 {! $Resource.XXX} 的方式调用静态资源

- 代码使用：

  ```xml
  <apex:page controller="GoodsController2">
      <!-- 可以指定标准扩展类的某一个get方法，返回值显示在页面上 , 省略get，不区分大小写-->
  	<apex:pageBlock title="所有Goods数据">
      	<apex:pageBlockTable value="{!Goodses}" var="goods">
          	<apex:column value="{!goods.Id}"/>
              <apex:column value="{!goods.GoodsName__c}"/>
          </apex:pageBlockTable>
      </apex:pageBlock>
      
      <!-- 使用静态资源 , 指定静态的图片 -->
      <img src="{!$Resource.img1}"/>
      
      <!-- 引入使用js文件 general_js 里面有一个函数 generalFunction()可以调用 -->
      <apex:includeScript value="{! $Resource.general_js }"/>
  
      <script type="text/javascript">
          generalFunction();
      </script>
      
      <!-- 可以使用 zip 压缩文件中的 文件 -->
      <!-- 压缩文件中有一个 styles文件夹 下面 有一个 default.css文件 -->
       <apex:stylesheet value="{!URLFOR($Resource.default_style, 'styles/default.css') }"/>
      
  </apex:page>
  ```

- 重定向到 salesforce标准列表页面

-  对于将用户导航到标准选项卡的按钮或链接，您可以重定向内容以显示标准对象的列表。 

  ```xml
  <apex:page action="{!URLFOR($Action.Account.List, $ObjectType.Account)}"/>
  
  <apex:page action="{!URLFOR($Action.Contact.List, $ObjectType.Contact)}"/>
  ```

## 使用从属字段PickList

- 实现当点击 当前的  农业 ， 然后展示当前 农业下面的 苹果农场，玉米田等等..

- 可以用作 省市级联操作

- 创建 从属字段步骤：
  - 从帐户的对象管理设置中，转到字段区域，然后单击“ **新建”**。
  - 选择“选择**列表”**，然后单击“ **下一步”**。
  - 输入Subcategories的**字段标签**。
  - 为值列表输入以下术语：
    - 苹果农场
    - 电缆
    - 玉米田
    - 互联网
    - 无线电
    - 电视
    - 酒厂
  - 单击**下一步**两次，然后单击 **保存**。

- 要定义子类别的字段依赖性：

  1. 从帐户的对象管理设置中，转到字段区域。
  2. 单击**字段依赖项**。
  3. 点击**新建**。
  4. 选择行业作为控制字段，选择子类别作为从属字段。
  5. 点击**继续**。
  6. 控制字段（来自行业）中的每个值都列在第一行中，从属字段（来自子类别）中的每个值都显示在其下面的列中。设置字段依赖项以匹配此图像:
  7. ![](assets\7.png)

- 代码操作：

  ```xml
  <apex:page standardController="Account">
      <apex:form >
          <apex:pageBlock mode="edit">
              <apex:pageBlockButtons >
                  <!-- 进行保存之后，就能将Subcategories__c 这个字段设置为 具体的一个值 -->
                  <apex:commandButton action="{!save}" value="Save"/>
              </apex:pageBlockButtons>
              <apex:pageBlockSection title="Dependent Picklists" columns="2">
               <!-- 使用inputField 为下拉列表展示  industry 行业-->
              <apex:inputField value="{!account.industry}"/>
               <!-- 通过上面行业的选择，而展现出每个行业下的内容-->
              <apex:inputField value="{!account.subcategories__c}"/>
              </apex:pageBlockSection>
          </apex:pageBlock>
      </apex:form>
  </apex:page>
  ```

  ![](assets\8.png)

## 启用内联编辑

-  内联编辑使用户可以在记录的详细信息页面上快速编辑字段值。![可编辑字段](https://developer.salesforce.com/docs/resources/img/en-us/224.0?doc_id=img%2Ffunc_icons%2Futil%2Fpencil12.gif&folder=pages)当您将鼠标悬停在单元格上方时，可编辑单元格将显示铅笔图标（），而不可编辑单元格将显示锁定图标（![无法编辑的栏位](https://developer.salesforce.com/docs/resources/img/en-us/224.0?doc_id=img%2Ffunc_icons%2Futil%2Flock12.gif&folder=pages)）。 

### 默认界面的内联编辑

- 使用 detail 默认界面展示信息，并且开启 内联编辑

- 代码：

  ```xml
  <apex:page standardController="Account">
      	<!-- detail默认界面展示信息 ， relatedList不显示联系人列表信息  -->
      	<!-- inlineEdit 开启内联编辑功能,默认双击进行修改 -->
          <apex:detail subject="{!account.Id}"  relatedList="false" inlineEdit="true"/> 
  </apex:page>
  ```

- 效果图：

  ![](assets\10.png)

### form表单中内联编辑

- 内联编辑组件：`<apex:inlineEditSupport>` 支持内联编辑的组件必须是 包含在下面组件之中。

  ```xml
  <apex：dataList >
  <apex：dataTable >
  <apex：form >
  <apex：outputField >
  <apex：pageBlock >
  <apex：pageBlockSection >
  <apex：pageBlockTable >
  <apex：repeat >
  ```

- 代码示例：

  ```xml
  <apex:page standardController="Account" recordSetVar="records" id="thePage"> 
      <apex:form id="theForm"> 
          <apex:pageBlock id="thePageBlock"> 
              <!-- 循环展示 Account中records 标签内容 -->
              <apex:pageBlockTable value="{!records}" var="record" id="thePageBlockTable"> 
                  
                  <apex:column >
                      <apex:outputField value="{!record.Name}" id="AccountNameDOM" /> 
                      <!-- facet展示列表头名称 -->
                      <apex:facet name="header">Name</apex:facet>
                  </apex:column>
                  
                  <apex:column >
                      <apex:outputField value="{!record.Type}" id="AccountTypeDOM" /> 
                      <apex:facet name="header">Type</apex:facet>
                  </apex:column>
                  <apex:column >
                      <apex:outputField value="{!record.Industry}" 
                          id="AccountIndustryDOM" />  
                          <apex:facet name="header">Industry</apex:facet>
                  </apex:column>
                  
  				<!-- 开启内联编辑，event设置双击 开启编辑内容 -->
                  <!-- showOnEdit双击内联编辑后 要展示的button按钮 -->
                 <!-- hideButton 双击内联编辑后，隐藏的button按钮 -->
                  <apex:inlineEditSupport event="ondblClick" 
                          showOnEdit="saveButton,cancelButton" hideOnEdit="editButton" /> 
                  
                 
              </apex:pageBlockTable> 
              <!-- Button按钮绑定一个id，交给inlineEditSupport进行隐藏或展示 -->
              <apex:pageBlockButtons > 
                  <apex:commandButton value="Edit" action="{!save}" id="editButton" />
                  <apex:commandButton value="Save" action="{!save}" id="saveButton" />
                  <apex:commandButton value="Cancel" action="{!cancel}" id="cancelButton" />
              </apex:pageBlockButtons> 
          </apex:pageBlock> 
      </apex:form>
  </apex:page>
  ```

### 具体单个标签启动内联编辑

- 可以启用 内联编辑的标签：

  ```xml
  <apex：dataList >
  <apex：dataTable >
  <apex：form >
  <apex：outputField >
  <apex：pageBlock >
  <apex：pageBlockSection >
  <apex：pageBlockTable >
  <apex：repeat >
  ```

- 代码：

  ```xml
  <apex:page standardController="Account">
      <apex:form>
          <!-- Don't mix a standard input field... -->
          <apex:inputField value="{!account.Name}"/>
          
          <!-- 在具体的outputField中写入inlineEditSupport 组件，就只会在当前下生效 -->
          <apex:outputField value="{!account.Name}">
              <!-- ...with an inline-edit enabled dependent field -->
              <apex:inlineEditSupport event="ondblClick" />
          </apex:outputField>
      </apex:form>
  </apex:page>
  ```



---



## 页面使用Ajax

- 某些Visualforce组件可以识别Ajax，并允许将Ajax行为添加到页面而无需编写任何JavaScript。

### 连接实现部分页面刷新

- 之前调用 commandList 重新渲染数据时，是将整个页面都重新渲染，而现在只想让一部分页面进行刷新。

- commandList 通过 rerender  绑定显示数据组件的 id。

- 代码：

  ```xml
  <apex:page standardController="Account">
      <apex:pageBlock title="Hello {!$User.FirstName}!">
          You are displaying contacts from the {!account.name} account. 
          Click a contact's name to view his or her details.
      </apex:pageBlock>
      <apex:pageBlock title="Contacts">
          <apex:form>
              <apex:dataTable value="{!account.Contacts}" var="contact" cellPadding="4" 
                                 border="1">
                    <apex:column>
                        
                        <!-- rerender设置部分刷新页面的组件 id -->
                        <apex:commandLink rerender="detail"> 
                            {!contact.Name}
                            <apex:param name="cid" value="{!contact.id}"/>
                        </apex:commandLink>
                        
                    </apex:column>
              </apex:dataTable>
          </apex:form>
      </apex:pageBlock>
      
      <!-- outputPanel输出面板，展示输出的数据 -->
      <apex:outputPanel id="detail"> 
          <apex:detail subject="{!$CurrentPage.parameters.cid}" relatedList="false" 
                          title="false"/>
      </apex:outputPanel>
  </apex:page>
  ```

### 将Ajax行为应用与任何组件

- 假设现在需要 只通过将鼠标悬停在联系人姓名上就可以进行相同的页面更新

-  将联系人姓名包装在 <apex：outputPanel >标记。在此输出面板中，添加一个<apex：actionSupport > 元素作为联系人姓名的同级： 

-  <apex：outputPanel > 标签定义了我们想要特殊行为的区域。 

-   <apex：actionSupport > 标签定义了先前由命令链接实现的部分页面更新行为 。可以添加 事件行为

  ```xml
  <apex:page standardController="Account">
      <apex:pageBlock title="Contacts">
          <apex:form>
              <apex:dataTable value="{!account.Contacts}" var="contact" cellPadding="4" 
                                 border="1">
                    <apex:column>
                        
                        <!-- 修改为当鼠标停靠在 name名称是，就进行 页面的局部刷新 -->
                        <!-- 需要包含在 outputPanel 输出布局中，actionSupport定义一个从 父标签的行为 -->
                        <!-- actionSupport和commandList其他属性基本一致 -->
                        <apex:outputPanel>
                            <apex:actionSupport event="onmouseover" rerender="detail"> 
                                <apex:param name="cid" value="{!contact.id}"/>
                                132
                            </apex:actionSupport> 
                            {!contact.Name}
                        </apex:outputPanel> 
                    </apex:column>
              </apex:dataTable>
          </apex:form>
      </apex:pageBlock>
      <apex:outputPanel id="detail">
          <apex:actionStatus startText="Requesting...">
              <apex:facet name="stop">
                  <apex:detail subject="{!$CurrentPage.parameters.cid}" relatedList="false" 
                                  title="false"/>
              </apex:facet>
          </apex:actionStatus>
      </apex:outputPanel>
  </apex:page>
  ```

  

## 页面转为PDF文件展示

- `<apex:page>` 中的 renderAs  属性可以指定，页面为什么格式 展现。

- 代码：

  ```xml
  <apex:page standardController="Account" renderAs="pdf" applyBodyTag="false">
      <!-- renderAs设置展示的效果为 pdf格式 ,applyBodyTag设置为false，可以body中使用css样式 -->
      <head>
          <style> 
              body { font-family: 'Arial Unicode MS'; }
              .companyName { font: bold 30px; color: red; }  
          </style>
      </head>
      <body>
          <!-- center将标签中的内容 居中展示 -->
          <center>
          <h1>New Account Name!</h1>
       
          <!-- panelGrid设置布局，columns设置一行展示几列数据 width设置宽度多少-->
          <apex:panelGrid columns="1" width="100%">
              <apex:outputText value="{!account.Name}" styleClass="companyName"/>
              <apex:outputText value="{!NOW()}"></apex:outputText>
          </apex:panelGrid>
              
          </center>
      </body>
  </apex:page>
  ```

  



---

## 1.分页操作

- 在Apex中 通过 ApexPages.StandardSetController 属性中的方法，可以进行数据库的查询。并且进行分页操作。

- ApexPages.StandardSetController方法：

  ```java
  con = new ApexPages.StandardSetController(Database.getQueryLocator([.....]));
  通过 构造方法 封装一个数据库查询出的数据 . 封装为分页
  
  con.setPageSize(3); 设置每页数据为3条
  con.getRecords();  获取数据
  con.getHasNext(); 是否为下一页
  con.getHasPrevious(); 是否还有上一页
  con.getPageNumber(); 当前是第几页
  con.first();   返回第一页
  con.last();   返回最后一页
  con.previous();    上一页
  con.next();    下一页
      
    	getPageSize() 返回总页数 , 从 0 开始
      getListViewOption() 返回一个选择列表
      setPageNumber(1);  设置跳转到那一页
      getResultSize(); 返回总记录数
      
  ```

- Apex——Controller代码：

  ```java
  <apex:page controller="PagingController">
      <apex:form >
          <apex:pageBlock title="Goods">
  			<!-- 展示报错信息的标签 -->
              <apex:pageMessages />
  
              <apex:pageBlockSection title="Goods -  Page 当前页：{!pageNumber}  总页数：{!Nums.size}" columns="1">
                  <apex:pageBlockTable value="{!goodses}" var="c">
                      <apex:column width="25px">
                          <apex:inputCheckbox value="{!c.IsStatus__c}" />
                      </apex:column>
                      
                      <!-- headerValue指定这一列的 列头名称 -->
                      <apex:column value="{!c.GoodsName__c}" headerValue="Name" />
                      <apex:column value="{!c.GoodsType__c}" headerValue="type" />
                      <apex:column value="{!c.GoodsBrand__c}" headerValue="brand" />
                      <apex:column value="{!c.GoodsPrice__c}" headerValue="Price" />
                  </apex:pageBlockTable>
              </apex:pageBlockSection>
         
  
          	<apex:pageBlockButtons location="bottom">
                  <apex:commandButton action="{!first}" value="First" />
                  <apex:commandButton action="{!previous}" rendered="{!hasPrevious}" value="Previous" />
                  <apex:commandButton action="{!next}" rendered="{!hasNext}" value="Next" />
                  <apex:commandButton action="{!last}" value="Last" />
                  <apex:commandButton action="{!pageNum}" value="第1页" />
                  
                  <apex:pageBlockSection>
                  	<!-- 进行页数的跳转 -->
                      <apex:selectList multiselect="false" size="1" 
                          label="分页跳转:" onchange="chanNum()" value="{!pageNum}">
                          
                          <!-- 中间方法，通过actionFunction 来调用controller方法 -->
                          <apex:actionFunction action="{!pageNum}" name="chanNum"/>
                          
                          <apex:selectOptions value="{!Nums}">
                          </apex:selectOptions>
                      </apex:selectList>
                  </apex:pageBlockSection>
                  
              </apex:pageBlockButtons>
              
              
  
          </apex:pageBlock>
      </apex:form>
      
      <script>
      	function pageNum(){
              //获取当前点击的页码
          }
      </script>
  </apex:page>
  ```

- VF Page 代码：

  ```xml
  public with sharing class PagingController {
  
      List<Goods__c> goodses {get;set;}
      
      public String pageNum {get;set;}
  
      // instantiate the StandardSetController from a query locator
      public ApexPages.StandardSetController con {
          get {
              //当方法中 con.xxxx 调用con时，就会进行判断是否为null ，为null就查询出数据
              if(con == null) {
                  con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT  GOODSBRAND__c,GOODSDESCRIBE__c,GOODSNAME__c, GOODSTYPE__c, GoodsPrice__c, IsStatus__c, Id FROM GOODS__c limit 100]));
                  // 设置 con 每页数据是多少 , con中自动封装了一些 分页的方法
                  con.setPageSize(3);
              }
              return con;
          }
          set;
      }
  
      // 获取 数据列表
      public List<Goods__c> getGoodses() {
          //创建一个 categoryWrapper 集合
          goodses = new List<Goods__c>();
          //通过 con的 getRecords 自封装方法，获取 Goods__c 列表集合
          //for (GOODS__c category1 : (List<GOODS__c>)con.getRecords())
              //判断复选框是否选中了
              //赋值到categories 中返回
            //  goodses.add(category1);
          
          goodses = (List<GOODS__c>)con.getRecords();
          System.debug(goodses);
  
          return goodses;
      }
  
      // 判断是否还有下一页
      public Boolean hasNext {
          get {
              return con.getHasNext();
          }
          set;
      }
  
      // 判断是否还有上一页
      public Boolean hasPrevious {
          get {
              return con.getHasPrevious();
          }
          set;
      }
  
      // 得出当前是第几页
      public Integer pageNumber {
          get {
              return con.getPageNumber();
          }
          set;
      }
  
      // 返回第一页
       public void first() {
           //如果没有 对象的外层嵌套，需要con.save 先保存一下。在跳转
           //con.save();
           con.first();
           //将pageNum 设置为 跳转后的 页面数
           pageNum = pageNumber.format();
       }
  
       //最后一页
       public void last() {
           con.last();
           //将pageNum 设置为 跳转后的 页面数
           pageNum = pageNumber.format();
       }
  
       //上一页
       public void previous() {
           con.previous();
           //将pageNum 设置为 跳转后的 页面数
           pageNum = pageNumber.format();
       }
  
       // 下一页
       public void next() {
           con.next();
           //将pageNum 设置为 跳转后的 页面数
           pageNum = pageNumber.format();
       }
      
      //返回总页数 , 从0开始计算
      public List<selectOption> getNums(){
          List<selectOption> nums = new List<selectOption>();
          for(integer i = 0 ; i < con.getPageSize()+1 ; i++){
              nums.add(new SelectOption(i+1+'' , i+1+''));
          }
          return nums;
      }
      
      //设置跳转到那一页
      public void pageNum(){
          System.debug(pageNum);
          con.setPageNumber(integer.valueof(pageNum));
      }
      
  }
  ```

