import 'dart:io';
import 'dart:typed_data';

class CommonTool {
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
  static Future<bool> saveImage(
      Uint8List? imageBytes, String path, String fileName) async {
    if (imageBytes == null) {
      print("imageBytes is null");
      return false;
    }
    // 获取图片保存目录
    Directory directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    File imageFile = File(path + fileName);

    try {
      await imageFile.writeAsBytes(imageBytes); // 将图片数据写入文件
      return true; // 返回保存的图片路径
    } catch (e) {
      print('保存图片出错：$e');
      return false;
    }
  }
}
