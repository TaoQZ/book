```shell
#x86下载二进制文件
wget https://www.moerats.com/usr/down/ffmpeg/ffmpeg-git-32bit-static.tar.xz
#x86_64下载二进制文件
wget https://www.moerats.com/usr/down/ffmpeg/ffmpeg-git-64bit-static.tar.xz

#解压文件
tar -xvf ffmpeg-git-64bit-static.tar.xz 
#tar xvf ffmpeg-git-*-static.tar.xz && rm -rf ffmpeg-git-*-static.tar.xz

#将ffmpeg和ffprobe可执行文件移至/usr/bin方便系统直接调用
mv ffmpeg-git-*/ffmpeg  ffmpeg-git-*/ffprobe /usr/bin/

#查看版本
ffmpeg
ffprobe

# 反转视频
./ffmpeg -i /usr/local/ffmpeg/oceans.mp4 -vf reverse -af areverse -preset superfast /usr/local/ffmpeg/reverse.mp4
```

