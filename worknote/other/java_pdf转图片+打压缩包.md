依赖

```xml
<!--        pdf转image start-->
<dependency>
    <groupId>commons-logging</groupId>
    <artifactId>commons-logging</artifactId>
    <version>1.2</version>
</dependency>
<dependency>
    <groupId>org.apache.pdfbox</groupId>
    <artifactId>fontbox</artifactId>
    <version>2.0.1</version>
</dependency>
<dependency>
    <groupId>org.apache.pdfbox</groupId>
    <artifactId>pdfbox</artifactId>
    <version>2.0.1</version>
</dependency>
<!--        pdf转image end-->

<!-- https://mvnrepository.com/artifact/cn.hutool/hutool-all -->
<dependency>
    <groupId>cn.hutool</groupId>
    <artifactId>hutool-all</artifactId>
    <version>5.3.3</version>
</dependency>
```

```java
package com.tifenpai.plum.common.util;

import cn.hutool.core.io.FileUtil;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * @author taoqz
 * Created by taoqz on 2020/11/3.
 */
public class PdfCovertImageUtil {

    private static final Logger log = LoggerFactory.getLogger(PdfCovertImageUtil.class);

    @Test
    public void demo() {
        String fileName = "人教版九年级全一册初中英语电子课本（2013年最新版）.pdf";
        fileName = fileName.substring(0, fileName.lastIndexOf("."));
        System.out.println(fileName);
    }

    public static File covert(String fileTempPath, MultipartFile file) throws IOException {
        long currentTimeMillis = System.currentTimeMillis();
        File parentDir = new File(fileTempPath, String.valueOf(currentTimeMillis));
        boolean mkdir = parentDir.mkdir();

        // 将pdf文件下载到指定的文件夹下,进行pdf转图片之后删除源文件
        InputStream inputStream = file.getInputStream();
        String fileName = file.getOriginalFilename();
        String prefix = fileName.substring(0, fileName.lastIndexOf("."));
        String suffix = fileName.substring(fileName.lastIndexOf("."), fileName.length());
        File pdfFilePath = new File(fileTempPath, prefix + "_" + currentTimeMillis + "_" + suffix);

        BufferedInputStream bis = new BufferedInputStream(inputStream);
        BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(pdfFilePath));

        int len;
        byte[] bytes = new byte[1024];
        while ((len = bis.read(bytes)) != -1) {
            bos.write(bytes);
            bos.flush();
        }

        bos.close();
        bis.close();

//        加载PDF文件
//        PdfDocument doc = new PdfDocument();
//        doc.loadFromFile(pdfFilePath.getAbsolutePath());
//        保存PDF的每一页到图片
        BufferedImage image;

        PDDocument doc = PDDocument.load(pdfFilePath);
        PDFRenderer renderer = new PDFRenderer(doc);
        System.out.println(doc.getPages().getCount());

        int count = doc.getPages().getCount();
        int zeroNum = 3;
        if (count >= 1000) {
            zeroNum = String.valueOf(doc.getPages().getCount()).length();
        }
        for (int i = 0; i < doc.getPages().getCount(); i++) {
            image = renderer.renderImage(i, 1.25f);
            String imageNum = numPreAddZero(String.valueOf(i), zeroNum);
            File imageFile = new File(parentDir, String.format("%s.png", imageNum));
            System.out.println(imageFile.getAbsolutePath());
            ImageIO.write(image, "PNG", imageFile);
        }

        doc.close();

        String sourceFilePath = parentDir.getAbsolutePath();
        String targetPath = parentDir.getParent();
        String zipFileName = parentDir.getName() + ".zip";

        System.out.println(sourceFilePath);
        System.out.println(targetPath);
        System.out.println(zipFileName);
        createZipFile(sourceFilePath, targetPath, zipFileName);

        try {
            Thread.sleep(2000);
            log.info("删除文件");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        FileUtil.del(sourceFilePath);
        FileUtil.del(pdfFilePath);
        return new File(targetPath, zipFileName);
    }

    public static String numPreAddZero(String num, int len) {
        int intHao = Integer.parseInt(num);
        intHao++;
        StringBuilder strHao = new StringBuilder(Integer.toString(intHao));
        while (strHao.length() < len) {
            strHao.insert(0, "0");
        }
        return strHao.toString();
    }


    public static boolean createZipFile(String sourceFilePath, String targetPath, String zipFileName) {

        boolean flag = false;
        FileOutputStream fos = null;
        ZipOutputStream zos = null;

        // 要压缩的文件资源
        File sourceFile = new File(sourceFilePath);
        // zip文件存放路径
        String zipPath = "";

        if (null != targetPath && !"".equals(targetPath)) {
            zipPath = targetPath + File.separator + zipFileName;
        } else {
            zipPath = new File(sourceFilePath).getParent() + File.separator + zipFileName;
        }

        if (sourceFile.exists() == false) {
            System.out.println("待压缩的文件目录：" + sourceFilePath + "不存在.");
            return flag;
        }

        try {
            File zipFile = new File(zipPath);
            if (zipFile.exists()) {
                log.error(zipPath + "目录下存在名字为:" + zipFileName + ".zip" + "打包文件.");
            } else {
                File[] sourceFiles = sourceFile.listFiles();
                if (null == sourceFiles || sourceFiles.length < 1) {
                    log.error("待压缩的文件目录：" + sourceFilePath + "里面不存在文件，无需压缩.");
                } else {
                    fos = new FileOutputStream(zipPath);
                    zos = new ZipOutputStream(new BufferedOutputStream(fos));
                    // 生成压缩文件
                    writeZip(sourceFile, "", zos);
                    flag = true;
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } finally {
            //关闭流
            try {
                if (null != zos) {
                    zos.close();
                }
                if (null != fos) {
                    fos.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return flag;
    }

    private static void writeZip(File file, String parentPath, ZipOutputStream zos) {
        if (file.exists()) {
            // 处理文件夹
            if (file.isDirectory()) {
                parentPath += file.getName() + File.separator;
                File[] files = file.listFiles();
                if (files.length != 0) {
                    for (File f : files) {
                        // 递归调用
                        writeZip(f, parentPath, zos);
                    }
                } else {
                    // 空目录则创建当前目录的ZipEntry
                    try {
                        zos.putNextEntry(new ZipEntry(parentPath));
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            } else {
                FileInputStream fis = null;
                try {
                    fis = new FileInputStream(file);
                    ZipEntry ze = new ZipEntry(parentPath + file.getName());
                    zos.putNextEntry(ze);
                    byte[] content = new byte[1024];
                    int len;
                    while ((len = fis.read(content)) != -1) {
                        zos.write(content, 0, len);
                        zos.flush();
                    }
                } catch (FileNotFoundException e) {
                    log.error("创建ZIP文件失败", e);
                } catch (IOException e) {
                    log.error("创建ZIP文件失败", e);
                } finally {
                    try {
                        if (fis != null) {
                            fis.close();
                        }
                    } catch (IOException e) {
                        log.error("创建ZIP文件失败", e);
                    }
                }
            }
        }
    }
}
```

