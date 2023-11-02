# HL视频笔记

### 我们需要你！加入我们吧！

##### 我们需要你的加入！不论你是否会写代码，都可加入我们！

- **狗头策划组**：未来目标的规划者，发展方向的引路人。
- **UI设计组**：对于UI、图标、颜色、交互体验等等有自己的看法的小哥哥小姐姐们。
- **测试反馈组**：HL视频笔记的真爱粉，希望它变得更好的粉粉们。
- **开发编程组**：攻克技术壁垒的攻城狮们。
- **翻译组**：化解语言的迷雾，让不同文化间的交流变得如丝般顺滑。

### 开发目标

- [x] 视频快速截图
- [x] 插入视频节点
- [x] 白板功能
- [ ] 手写区域扩大
- [ ] 荧光笔
- [x] 插入本地图片
- [ ] 图片调整大小、裁剪，修改截图
- [ ] 在图片上绘制
- [ ] 插入本地视频
- [ ] 长按快进
- [ ] 录音
- [ ] 视频字幕
- [ ] 截取视频片段
- [ ] ORC识别
- [ ] pdf做笔记
- [ ] 插件系统
- [ ] bilibili、YouTube
- [ ] 百度网盘、阿里网盘、cctalk
- [ ] 笔记导出（pdf、图片、HTML...）
- [ ] 支持Markdown
- [ ] 视频倍速
- [ ] 视频缩放
- [ ] 视频浮动在页面上，自由缩放移动
- [ ] 横屏竖屏切换
- [ ] chatGPT
- [ ] 视频全屏后，一些功能变成悬浮按钮
- [ ] 分享视频
- [ ] 分享笔记
- [ ] 手机平板联动、一个看视频一个写笔记，功能拆分。
- [ ] 实时语音转文字
- [ ] 网页视频

### 开发环境

Flutter 3.10.6 • channel stable

Tools • Dart 3.0.6 • DevTools 2.23.1

[!] Flutter (Channel stable, 3.10.6, on Microsoft Windows [版本 10.0.19043.1586], locale zh-CN)

[√] Windows Version (Installed version of Windows is version 10 or higher)

[√] Android toolchain - develop for Android devices (Android SDK version 34.0.0)

[√] Chrome - develop for the web

[√] Visual Studio - develop for Windows (Visual Studio Professional 2019 16.11.24)

[√] Android Studio (version 2022.3)

[√] Connected device (3 available)

#### Windows

运行时依赖很可能拉取不下来，主要是media_kit的依赖

```
Launching lib\main.dart on Windows in debug mode...
CMake Error at flutter/ephemeral/.plugin_symlinks/media_kit_libs_windows_video/windows/CMakeLists.txt:40 (message):
  C:/Users/moli/Flutter/Note/note/build/windows/mpv-dev-x86_64-20230924-git-652a1dd.7z
  Integrity check failed, please try to re-build project again.
Call Stack (most recent call first):
flutter/ephemeral/.plugin_symlinks/media_kit_libs_windows_video/windows/CMakeLists.txt:74 (download_and_verify)

Exception: Unable to generate build files
```

(上面代码是mpv-dev-x86_64-20230924-git-652a1dd.7z拉取不下来)请前往https:
//github.com/media-kit/libmpv-win32-video-build/releases/ 下载对应的文件并拷贝覆盖到项目目录的build/windows下

media_kit依赖https://github.com/alexmercerind/flutter-windows-ANGLE-OpenGL-ES 所以还会报错

```
Launching lib\main.dart on Windows in debug mode...
main.dart:1
CMake Error at flutter/ephemeral/.plugin_symlinks/media_kit_libs_windows_video/windows/CMakeLists.txt:40 (message):
  C:/Users/moli/Flutter/Note/note/build/windows/ANGLE.7z Integrity check
  failed, please try to re-build project again.
Call Stack (most recent call first):
flutter/ephemeral/.plugin_symlinks/media_kit_libs_windows_video/windows/CMakeLists.txt:110 (download_and_verify)

Exception: Unable to generate build files
```

(上面代码是ANGLE.7z拉取不下来)请前往https:
//github.com/alexmercerind/flutter-windows-ANGLE-OpenGL-ES/releases/download/v1.0.0/ANGLE.7z
下载对应的文件并拷贝覆盖到项目目录的build/windows下

还可能出现错误:

```
Error waiting for a debug connection: The log reader stopped unexpectedly, or never started.
Error launching application on Windows.
```

一般是缓存的问题，清理一下:flutter clean，再拉取一下依赖一般就可以了，如果还不行请尝试删除windows目录再创建flutter
create . 重新添加。

~~注意以下文件夹下的子文件夹必须为链接~~
~~windows/flutter/ephemeral/.plugin_symlinks/~~
~~linux/flutter/ephemeral/.plugin_symlinks/~~

#### Android

**PS：请一定要开启AS->settings->Languages&Frameworks->Flutter->Enable verbose logging**

**可以查看输出日志，方便调试**

权限问题AndroidManifest.xml

```xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
    <application android:preserveLegacyExternalStorage="true"
        android:requestLegacyExternalStorage="true" android:label="note"
        android:name="${applicationName}" android:icon="@mipmap/ic_launcher">
```

运行时依赖很可能拉取不下来，主要是media_kit的依赖

请前往[https://github.com/media-kit/libmpv-android-video-build/releases](https://github.com/media-kit/libmpv-android-video-build/releases)
下载对应的文件并拷贝覆盖到项目目录的build/media_kit_libs_android_video/{$版本号 如v1.1.5}下(
一般是default-arm64-v8a.jar、default-armeabi-v7a.jar、default-x86.jar、default-x86_64.jar拉取不下来)

