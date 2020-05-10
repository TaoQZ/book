查看当前连接设备

```
adb devices	
```

重启设备到bootloader

```
adb reboot bootloader
```

查看fastboot设备

```
fastboot devices
```

解锁

```
fastboot oem unlock
```

上锁

```
fastboot oem lock
```

刷入twrp

查看设备对应的twrp

```
https://twrp.me/Devices/
```

```
fastboot flash recovery twrp.img
```

使手机进入到twrp界面

```
fastboot boot twrp.img
```

线刷

首先需要进入twrp,选择高级重启中的adb asideload

电脑adb命令行输入

```
adb sideload 刷机包
```

