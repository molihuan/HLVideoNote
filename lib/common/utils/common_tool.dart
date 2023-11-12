import 'package:flutter/material.dart';

///方法类型
typedef String StrCallbackStr(String value);
typedef void CallbackStr(String value);
typedef String StrCallback();

typedef Widget WgetCallback();

typedef Future<String> FStrCallbackStr(String value);
typedef Future<void> FCallbackStr(String value);
typedef Future<String> FStrCallback();

class CommonTool {
  ///String转Duration
  static Duration str2Duration(String durationString) {
    List<String> parts = durationString.split(':');

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  ///格式化日期
  ///return 2023年11月12日 16:05
  ///
  static String getFormattedTime(DateTime dateTime) {
    final formattedDate =
        '${dateTime.year.toString()}年${dateTime.month.toString().padLeft(2, '0')}月${dateTime.day.toString().padLeft(2, '0')}日';
    final formattedTime =
        '${formattedDate} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  ///获取当前时间
  static String getCurrentTime() {
    DateTime dateTime = DateTime.now();
    final formattedDate =
        '${dateTime.year.toString()}_${dateTime.month.toString().padLeft(2, '0')}_${dateTime.day.toString().padLeft(2, '0')}';
    final formattedTime =
        '${formattedDate}_${dateTime.hour.toString().padLeft(2, '0')}_${dateTime.minute.toString().padLeft(2, '0')}_${dateTime.second.toString().padLeft(2, '0')}_${dateTime.millisecondsSinceEpoch.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  ///获取上一级url
  static String? getParentUrl(String url) {
    if (url.isEmpty) {
      return null;
    }

    ///如果是以路径分隔符结尾则去除最后的路径分隔符
    if (url.endsWith("/")) {
      url = url.substring(0, url.length - 1);
    }

    if (!url.contains("/")) {
      return null;
    }

    int endIndex = url.lastIndexOf("/");
    return url.substring(0, endIndex);
  }
}
