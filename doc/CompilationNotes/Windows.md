## Windows版编译注意事项

编译环境需要C++ 20，请注意Visual Studio版本，cmake需要3.23及以上，请到cmake官网下载安装包并替换Visual
Studio中的cmake(3.22)

编译时需要nuget.exe，请前往 [https://www.nuget.org/downloads](https://www.nuget.org/downloads)
下载并配置好环境变量。

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

（上面代码是mpv-dev-x86_64-20230924-git-652a1dd.7z拉取不下来）请前往[https://github.com/media-kit/libmpv-win32-video-build/releases/](https://github.com/media-kit/libmpv-win32-video-build/releases/)
下载对应的文件并拷贝覆盖到项目目录的build/windows下

media_kit依赖[https://github.com/alexmercerind/flutter-windows-ANGLE-OpenGL-ES](https://github.com/alexmercerind/flutter-windows-ANGLE-OpenGL-ES)
所以还会报错

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

（上面代码是ANGLE.7z拉取不下来）请前往[https://github.com/alexmercerind/flutter-windows-ANGLE-OpenGL-ES/releases/download/v1.0.0/ANGLE.7z](https://github.com/alexmercerind/flutter-windows-ANGLE-OpenGL-ES/releases/download/v1.0.0/ANGLE.7z)
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
