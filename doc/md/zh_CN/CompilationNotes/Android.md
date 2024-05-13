## Android版编译注意事项

**PS：请一定要开启Android Studio->settings->Languages&Frameworks->Flutter->Enable verbose logging**

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
        android:requestLegacyExternalStorage="true" android:label="videonote"
        android:name="${applicationName}" android:icon="@mipmap/ic_launcher">
```

运行时依赖很可能拉取不下来，主要是media_kit的依赖

请前往[https://github.com/media-kit/libmpv-android-video-build/releases](https://github.com/media-kit/libmpv-android-video-build/releases)
下载对应的文件并拷贝覆盖到项目目录的build/media_kit_libs_android_video/{$版本号
如v1.1.5}下（一般是default-arm64-v8a.jar、default-armeabi-v7a.jar、default-x86.jar、default-x86_64.jar拉取不下来）

## 注意



```sh
安卓的包名为：
com.molihuan.note

minSdkVersion 23

id "org.jetbrains.kotlin.android" version "1.9.24"
```



