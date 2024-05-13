import 'package:flutter/material.dart';

///方法类型
typedef String StrCallbackStr(String value);
typedef void CallbackStr(String value);
typedef String StrCallback();
typedef bool BoolCallback();

/// 异步方法
typedef Future<String> FStrCallbackStr(String value);
typedef Future<void> FCallbackStr(String value);
typedef Future<String> FStrCallback();

typedef Widget WgetCallback();

class CommonTool {

  Widget conditionalWidget(BoolCallback boolCallback, Widget widget) {
    bool condition = boolCallback();
    return condition ? widget : Visibility(visible: false, child: widget);
  }

  /// 获取父位置
  static String getParentPos(String path) {
    // 如果路径以斜杠结尾，先去掉斜杠
    if (path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }

    // 使用字符串匹配找到最后一个斜杠的位置
    int lastSlashIndex = path.lastIndexOf('/');

    // 如果找不到斜杠，或者斜杠在第一个位置，表示当前路径已经是根路径，直接返回原路径
    if (lastSlashIndex <= 0) {
      return path;
    }

    // 截取路径字符串，获取上一级路径
    return path.substring(0, lastSlashIndex);
  }



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
  ///2024_05_12_22_36_37_1715524597897
  static String getCurrentTime() {
    DateTime dateTime = DateTime.now();
    final formattedDate =
        '${dateTime.year.toString()}_${dateTime.month.toString().padLeft(2, '0')}_${dateTime.day.toString().padLeft(2, '0')}';
    final formattedTime =
        '${formattedDate}_${dateTime.hour.toString().padLeft(2, '0')}_${dateTime.minute.toString().padLeft(2, '0')}_${dateTime.second.toString().padLeft(2, '0')}_${dateTime.millisecondsSinceEpoch.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  ///获取上一级url
  // static String? getParentUrl(String url) {
  //   if (url.isEmpty) {
  //     return null;
  //   }
  //
  //   ///如果是以路径分隔符结尾则去除最后的路径分隔符
  //   if (url.endsWith("/")) {
  //     url = url.substring(0, url.length - 1);
  //   }
  //
  //   if (!url.contains("/")) {
  //     return null;
  //   }
  //
  //   int endIndex = url.lastIndexOf("/");
  //   return url.substring(0, endIndex);
  // }
}
