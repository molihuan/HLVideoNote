import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

enum RunningPlatform {
  android,
  ios,
  linux,
  macos,
  windows,
  web,
}

class PlatformTool {
  static bool isAndroid() => Platform.isAndroid;
  static bool isIOS() => Platform.isIOS;
  static bool isLinux() => Platform.isLinux;
  static bool isMacOS() => Platform.isMacOS;
  static bool isWindows() => Platform.isWindows;
  static bool isWeb() => kIsWeb;

  static RunningPlatform getCurrentPlatform() {
    if (Platform.isAndroid) {
      return RunningPlatform.android;
    } else if (Platform.isIOS) {
      return RunningPlatform.ios;
    } else if (Platform.isLinux) {
      return RunningPlatform.linux;
    } else if (Platform.isMacOS) {
      return RunningPlatform.macos;
    } else if (Platform.isWindows) {
      return RunningPlatform.windows;
    } else if (kIsWeb) {
      return RunningPlatform.web;
    } else {
      throw Exception('Unsupported platform');
    }
  }
}
