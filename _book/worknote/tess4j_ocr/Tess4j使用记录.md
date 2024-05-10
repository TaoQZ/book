Tess4j使用记录

springboot 依赖

```xml
<dependencies>
    <!--        图文识别 start-->
    <dependency>
        <groupId>net.sourceforge.tess4j</groupId>
        <artifactId>tess4j</artifactId>
        <version>4.5.1</version>
    </dependency>
    <!--        图文识别 end-->
</dependencies>

<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.google.cloud</groupId>
            <artifactId>libraries-bom</artifactId>
            <version>16.1.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

java代码

tessdata: 将tessdata文件夹放到resources目录下

```java
public class Tess4jUtil {

    public static String graphicRecognition(File imageFile, String language) throws TesseractException {
        // JNA Interface Mapping
        ITesseract instance = new Tesseract();
        // JNA Direct Mapping
        // ITesseract instance = new Tesseract1();
        //In case you don't have your own tessdata, let it also be extracted for you
        //这样就能使用classpath目录下的训练库了
        File tessDataFolder = LoadLibs.extractTessResources("tessdata");
        //Set the tessdata path
        instance.setDatapath(tessDataFolder.getAbsolutePath());
        instance.setTessVariable("user_defined_dpi", "300");
        //英文库识别数字比较准确
        instance.setLanguage(language);
        String result = instance.doOCR(imageFile);
        return result;
    }
}
```

训练字库

```shell
tesseract zwp.test.exp0.tif zwp.test.exp0  batch.nochop makebox

echo test 0 0 0 0 0 >font_properties
tesseract zwp.test.exp0.tif zwp.test.exp0 nobatch box.train
unicharset_extractor zwp.test.exp0.box
shapeclustering -F font_properties -U unicharset -O zwp.unicharset zwp.test.exp0.tr
mftraining -F font_properties -U unicharset -O zz.unicharset zwp.test.exp0.tr
cntraining zwp.test.exp0.tr
combine_tessdata zwp.
```

参考链接

安装与使用:
https://sourceforge.net/projects/tesseract-ocr-alt/files/
https://digi.bib.uni-mannheim.de/tesseract/
https://www.cnblogs.com/pejsidney/p/9487881.html
https://tesseract-ocr.github.io/tessdoc/Data-Files

文字训练:
https://www.cnblogs.com/xpwi/p/9604567.html
https://sourceforge.net/projects/vietocr/files/jTessBoxEditor/



训练字库
https://www.jianshu.com/p/c8ba23ec672a