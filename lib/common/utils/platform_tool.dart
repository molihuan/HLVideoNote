import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

import 'common_tool.dart';

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

  ///平台空回调
  static void voidCallback({
    VoidCallback? android,
    VoidCallback? ios,
    VoidCallback? linux,
    VoidCallback? windows,
    VoidCallback? mac,
    VoidCallback? web,
    VoidCallback? other,
  }) {
    callback<void, VoidCallback>(
        android: android,
        ios: ios,
        linux: linux,
        windows: windows,
        mac: mac,
        web: web,
        other: other);
  }

  static void voidFcallback({
    VoidFcallback? android,
    VoidFcallback? ios,
    VoidFcallback? linux,
    VoidFcallback? windows,
    VoidFcallback? mac,
    VoidFcallback? web,
    VoidFcallback? other,
  }) {
    fcallback<void, VoidFcallback>(
        android: android,
        ios: ios,
        linux: linux,
        windows: windows,
        mac: mac,
        web: web,
        other: other);
  }

  static Future<E?> fcallback<E, T extends Function>({
    T? android,
    T? ios,
    T? linux,
    T? windows,
    T? mac,
    T? web,
    T? other,
  }) async {
    return callback<E, T>(
        android: android,
        ios: ios,
        linux: linux,
        windows: windows,
        mac: mac,
        web: web,
        other: other);
  }

  ///平台回调
  ///[E] 返回类型
  ///[T] 方法类型,请看:common_tool.dart,也可自定义
  static E? callback<E, T extends Function>({
    T? android,
    T? ios,
    T? linux,
    T? windows,
    T? mac,
    T? web,
    T? other,
  }) {
    if (Platform.isAndroid) {
      if (android != null) {
        return android() as E;
      } else if (other != null) {
        return other() as E;
      }
    } else if (Platform.isIOS) {
      if (ios != null) {
        return ios() as E;
      } else if (other != null) {
        return other() as E;
      }
    } else if (Platform.isLinux) {
      if (linux != null) {
        return linux() as E;
      } else if (other != null) {
        return other() as E;
      }
    } else if (Platform.isMacOS) {
      if (mac != null) {
        return mac() as E;
      } else if (other != null) {
        return other() as E;
      }
    } else if (Platform.isWindows) {
      if (windows != null) {
        return windows() as E;
      } else if (other != null) {
        return other() as E;
      }
    } else if (kIsWeb) {
      if (web != null) {
        return web() as E;
      } else if (other != null) {
        return other() as E;
      }
    } else {
      throw Exception('Unsupported platform');
    }
    return null;
  }

  /**
   * 获取当前平台
   */
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
