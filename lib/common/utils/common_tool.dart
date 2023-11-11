import 'dart:io';
import 'dart:typed_data';

typedef String StrCallbackStr(String value);
typedef void CallbackStr(String value);
typedef String StrCallback();

typedef Future<String> FStrCallbackStr(String value);
typedef Future<void> FCallbackStr(String value);
typedef Future<String> FStrCallback();

class CommonTool {
  /**
   * string转Duration
   */
  static Duration str2Duration(String durationString) {
    List<String> parts = durationString.split(':');

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  /**
   * 格式化日期
   */
  static String getFormattedTime(DateTime dateTime) {
    final formattedDate =
        '${dateTime.year.toString()}年${dateTime.month.toString().padLeft(2, '0')}月${dateTime.day.toString().padLeft(2, '0')}日';
    final formattedTime =
        '${formattedDate} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  /**
   * 获取当前时间
   */
  static String getCurrentTime() {
    DateTime dateTime = DateTime.now();
    final formattedDate =
        '${dateTime.year.toString()}_${dateTime.month.toString().padLeft(2, '0')}_${dateTime.day.toString().padLeft(2, '0')}';
    final formattedTime =
        '${formattedDate}_${dateTime.hour.toString().padLeft(2, '0')}_${dateTime.minute.toString().padLeft(2, '0')}_${dateTime.second.toString().padLeft(2, '0')}_${dateTime.millisecondsSinceEpoch.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  /**
   * 保存图片
   */
  static Future<String?> saveImage(
      Uint8List? imageBytes, String path, String fileName) async {
    if (imageBytes == null) {
      print("imageBytes is null");
      return null;
    }
    // 获取图片保存目录
    Directory directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    String absolutePath = path + fileName;
    File imageFile = File(absolutePath);

    try {
      await imageFile.writeAsBytes(imageBytes); // 将图片数据写入文件
      return absolutePath; // 返回保存的图片路径
    } catch (e) {
      print('保存图片出错：$e');
      return null;
    }
  }
}
