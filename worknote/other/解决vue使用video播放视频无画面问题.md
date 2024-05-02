chrom只支持H264编码的MP4文件播放,在vue中使用H5中的video标签播放视频时无画面

在java中进行转换编码

maven导入jar包

```xml
<!--        mpeg4 TO H264 start-->
<dependency>
    <groupId>ws.schild</groupId>
    <artifactId>jave-core</artifactId>
    <version>2.4.5</version>
</dependency>
<dependency>
    <groupId>ws.schild</groupId>
    <artifactId>jave-native-win64</artifactId>
    <version>2.4.5</version>
</dependency>
<!--        mpeg4 TO H264 end-->
```

核心代码

```java
public class Mpeg4ToH264Util {

    private static Logger log = LoggerFactory.getLogger(Mpeg4ToH264Util.class);
    private static final String SOURCE = "sourcehomework";
    private static final String TARGET = "targethomework";

    public static String covertToH264(MultipartFile file, String tempPath, FileBusinessModuleEnum fileTypeEnum, FileUploadUtilByMinio fileUploadUtilByMinio) {

        // 将文件下载到本地,从本地读取出来后进行转码再生成文件上传到minio
        String filePath;
        long currentTimeMillis = System.currentTimeMillis();
        String suffix = Objects.requireNonNull(file.getOriginalFilename()).substring(file.getOriginalFilename().lastIndexOf("."));
        File localFile = new File(tempPath, SOURCE + "_" + currentTimeMillis + suffix);
        BufferedInputStream bis = null;
        BufferedOutputStream bos = null;
        try {
            bis = new BufferedInputStream(file.getInputStream());
            bos = new BufferedOutputStream(new FileOutputStream(localFile));
            int len;
            byte[] bytes = new byte[1024];
            while ((len = bis.read(bytes)) != -1) {
                bos.write(bytes);
                bos.flush();
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                bis.close();
                bos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        File target = new File(tempPath, TARGET + "_" + currentTimeMillis + suffix);
        log.info("转换前的路径:" + localFile);
        log.info("转换后的路径:" + target);
        AudioAttributes audio = new AudioAttributes();
        //音频编码格式
        audio.setCodec("libmp3lame");
        audio.setBitRate(800000);
        audio.setChannels(1);
        //audio.setSamplingRate(new Integer(22050));
        VideoAttributes video = new VideoAttributes();
        //视频编码格式
        video.setCodec("libx264");
        video.setBitRate(3200000);
        //数字设置小了，视频会卡顿
        video.setFrameRate(15);
        EncodingAttributes attrs = new EncodingAttributes();
        attrs.setFormat("mp4");
        attrs.setAudioAttributes(audio);
        attrs.setVideoAttributes(video);
        Encoder encoder = new Encoder();
        MultimediaObject multimediaObject = new MultimediaObject(localFile);
        try {
            log.info("Mpeg4转H264 --- 转换开始:" + new Date());
            encoder.encode(multimediaObject, target, attrs);
            log.info("Mpeg4转H264 --- 转换结束:" + new Date());
        } catch (Exception e) {
            log.info(localFile.getAbsolutePath() + "  转换失败");
            e.printStackTrace();
        }

        filePath = fileUploadUtilByMinio.uploadByFile(target, fileTypeEnum);
        localFile.delete();
        target.delete();
        return filePath;
    }
}
```





