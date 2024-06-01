## KeyCastOW
用于Windows的按键可视化工具，让您在录制屏幕视频时轻松显示您的按键。

感谢Brook Hong作者开发。

## AHK示例 

本软件结合 [ShareX](https://github.com/ShareX/ShareX) 和 [ANK](https://autohotkey.com/) 使用，每次截图能节约一些时间

[示例视频.webm](https://github.com/allrobot/KeyCastOW_chinese/assets/43485379/31a7c584-d820-4d9b-ad31-c4ccae7f52d9)

下载ank安装，ahk文件放置于`C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp`运行即可

### 所需工具：

 - [ShareX.exe](https://github.com/ShareX/ShareX)
 - [SetDpi.exe](https://github.com/imniko/SetDPI)
 - [ANK V2.0](https://autohotkey.com/)
 
 AHK文件仅支持<kbd>shift</kbd>+<kbd>alt</kbd>+<kbd>PrtSc截屏键</kbd>和<kbd>shift</kbd>+<kbd>PrtSc截屏键</kbd>弹出KeyCastOW程序，有需要的请参阅AHK文档自行添加、修改
 
### AHK思路

根据 [ShareX](https://getsharex.com/docs/command-line-arguments) 文档的ShareX [参数 ](https://github.com/ShareX/ShareX/blob/master/ShareX/Enums.cs) 

 - `"C:\Program Files\ShareX\ShareX.exe" -ScreenRecorderGIF`
 - `"C:\Program Files\ShareX\ShareX.exe"  -ScreenRecorder`
 
参阅 [AHK中文文档](https://wyagd001.github.io/v2/docs) 

先用 [SetDpi](https://github.com/imniko/SetDPI) 外部程序解析当前DPI倍率

当按下快捷键的时候，鼠标按下时拖动箭头自定义矩阵，松开后立刻捕获当前箭头相对于整个屏幕的坐标轴

坐标轴写入到KeyCast的配置文件，按键程序将显示在矩阵内部显示

>如果截屏面积小于按键，按键输出将占满截图面积，截屏矩阵分辨率最好大于144P，或者修改C++的源码即可，本人不怎么精通C++语言

如果检测到ffmpeg.exe进程已退出，说明截屏已完毕（ShareX截mp4或gif调用该进程），那么KeyCastOW程序也将退出

顺便调用`TrayIcon_Clean()`清理托盘图标

>没琢磨怎么隐藏命令行，有人做的比我更好可以Pull提交分支


### License


MIT License
