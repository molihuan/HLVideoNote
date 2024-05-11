## Mac版编译注意事项
环境：
```bash

[!] Flutter (Channel stable, 3.19.3, on macOS 13.4.1 22F82 darwin-x64, locale
    zh-Hans-CN)
    • Flutter version 3.19.3 on channel stable at /Users/macintoshhd/fvm/3.19.3
    ! Warning: `dart` on your path resolves to
      /usr/local/Cellar/dart/3.1.3/libexec/bin/dart, which is not inside your
      current Flutter SDK checkout at /Users/macintoshhd/fvm/3.19.3. Consider
      adding /Users/macintoshhd/fvm/3.19.3/bin to the front of your path.
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision ba39319843 (9 weeks ago), 2024-03-07 15:22:21 -0600
    • Engine revision 2e4ba9c6fb
    • Dart version 3.3.1
    • DevTools version 2.31.1
    • Pub download mirror https://pub.flutter-io.cn
    • Flutter download mirror https://storage.flutter-io.cn
    • If those were intentional, you can disregard the above warnings; however
      it is recommended to use "git" directly to perform update checks and
      upgrades.

[!] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
    • Android SDK at /Users/macintoshhd/environment/Android/SDK
    ✗ cmdline-tools component is missing
      Run `path/to/sdkmanager --install "cmdline-tools;latest"`
      See https://developer.android.com/studio/command-line for more details.
    ✗ Android license status unknown.
      Run `flutter doctor --android-licenses` to accept the SDK licenses.
      See https://flutter.dev/docs/get-started/install/macos#android-setup for
      more details.

[✓] Xcode - develop for iOS and macOS (Xcode 14.3.1)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 14E300c
    • CocoaPods version 1.15.2

[✗] Chrome - develop for the web (Cannot find Chrome executable at
    /Applications/Google Chrome.app/Contents/MacOS/Google Chrome)
    ! Cannot find Chrome. Try setting CHROME_EXECUTABLE to a Chrome executable.

[✓] Android Studio (version 2022.3)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build
      17.0.6+0-17.0.6b829.9-10027231)

[✓] Connected device (1 available)
    • macOS (desktop) • macos • darwin-x64 • macOS 13.4.1 22F82 darwin-x64

[✓] Network resources
    • All expected network resources are available.

```

flutter build macos

常用命令
打开ios模拟器
open -a Simulator
