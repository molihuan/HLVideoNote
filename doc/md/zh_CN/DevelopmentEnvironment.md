## 开发环境

```bash
[!] Flutter (Channel stable, 3.19.3, on Microsoft Windows [版本 10.0.19043.1586], locale zh-CN)
    • Flutter version 3.19.3 on channel stable at C:\Users\moli\fvm\default
    ! Warning: `flutter` on your path resolves to
      E:\DesktopSpace\Development\Environment\FlutterSDK\cache\3.19.3\bin\flutter, which is not inside your current
      Flutter SDK checkout at C:\Users\moli\fvm\default. Consider adding C:\Users\moli\fvm\default\bin to the front of
      your path.
    ! Warning: `dart` on your path resolves to E:\DesktopSpace\Development\Environment\FlutterSDK\cache\3.19.3\bin\dart,
      which is not inside your current Flutter SDK checkout at C:\Users\moli\fvm\default. Consider adding
      C:\Users\moli\fvm\default\bin to the front of your path.
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision ba39319843 (9 weeks ago), 2024-03-07 15:22:21 -0600
    • Engine revision 2e4ba9c6fb
    • Dart version 3.3.1
    • DevTools version 2.31.1
    • Pub download mirror https://pub.flutter-io.cn
    • Flutter download mirror https://storage.flutter-io.cn
    • If those were intentional, you can disregard the above warnings; however it is recommended to use "git" directly
      to perform update checks and upgrades.

[√] Windows Version (Installed version of Windows is version 10 or higher)

[√] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
    • Android SDK at E:\DesktopSpace\Development\Environment\Androidstudio\sdk
    • Platform android-34, build-tools 34.0.0
    • ANDROID_HOME = E:\DesktopSpace\Development\Environment\Androidstudio\sdk
    • Java binary at: E:\DesktopSpace\Development\Environment\Androidstudio\Androidstudio\jbr\bin\java
    • Java version OpenJDK Runtime Environment (build 17.0.10+0--11572160)
    • All Android licenses accepted.

[√] Chrome - develop for the web
    • Chrome at C:\Users\moli\AppData\Local\Google\Chrome\Application\chrome.exe

[√] Visual Studio - develop Windows apps (Visual Studio Community 2022 17.9.4)
    • Visual Studio at E:\DesktopSpace\Development\Environment\vs2019\Community
    • Visual Studio Community 2022 version 17.9.34714.143
    • Windows 10 SDK version 10.0.22621.0

[√] Android Studio (version 2023.3)
    • Android Studio at E:\DesktopSpace\Development\Environment\Androidstudio\Androidstudio
    • Flutter plugin can be installed from:
       https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
       https://plugins.jetbrains.com/plugin/6351-dart
    • android-studio-dir = E:\DesktopSpace\Development\Environment\Androidstudio\Androidstudio
    • Java version OpenJDK Runtime Environment (build 17.0.10+0--11572160)

[√] Connected device (4 available)
    • GM1910 (mobile)   • emulator-5554 • android-x64    • Android 9 (API 28)
    • Windows (desktop) • windows       • windows-x64    • Microsoft Windows [版本 10.0.19043.1586]
    • Chrome (web)      • chrome        • web-javascript • Google Chrome 123.0.6312.86
    • Edge (web)        • edge          • web-javascript • Microsoft Edge 114.0.1823.82 (unsupported)
```



## 常用命令

```shell
查看详细配置信息
flutter doctor -v
创建包名为com.molihuan.videonote的项目
flutter create --org com.molihuan videonote
创建所有平台
flutter create .
生成安卓端代码
flutter create --platforms android .
(安卓的包名必须为com.molihuan.note否则会白屏无法进入页面)
打包windows
flutter build windows
打包mac
flutter build macos
打包安卓分架构
flutter build apk --split-per-abi
打包ios
flutter build ios --release
```

## 注意在编译一些依赖时需要用到rust请安装并配置好rust

```sh
rustup 1.27.1 (54dd3d00f 2024-04-24)
info: This is the version for the rustup toolchain manager, not the rustc compiler.
info: The currently active `rustc` version is `rustc 1.78.0 (9b00956e5 2024-04-29)
```

